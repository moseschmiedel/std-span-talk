#import "@preview/iconic-salmon-svg:3.0.0": *
#import "@preview/touying:0.6.1": *
#import themes.simple: *

#set text(font: "Source Sans Pro")

#metadata((
  presented-at: "2025-06-24",
  time: "52m",
))

#let title = [`std::span`]
#let subtitle = [presentation for the course "C133 - OS Modern C++"]
#let author = [Mose Schmiedel]
#let date = datetime.today()
#let institution = [HTWK Leipzig \ University of Applied Sciences Leipzig]
#let logo = image("assets/HTWK_Zusatz_de_H_Black_sRGB.svg")

#let _sources_dict = state("sources", [])

#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: title,
    subtitle: subtitle,
    author: author,
    date: date,
    institution: institution,
    logo: logo,
  ),
  footer: [
    #context {
      text(20pt, fill: gray.darken(70%), _sources_dict.get())
      _sources_dict.update([])
    }
  ],
)

#show link: underline

#title-slide[
  #align(right)[#logo]
  #v(1fr)
  #box(fill: rgb("eee"), radius: 5pt, width: 100%, inset: 15pt)[
    #text(36pt, title)

    #text(24pt, fill: rgb("#222"), subtitle)
  ]

  #text(18pt)[
    #v(1fr)

    #date.display()

    #v(1fr)

    #author

    #institution
  ]
]

== outline
+ motivation
+ implementation
+ usage
+ std::mdspan
+ benefits and limitations

#v(1fr)

#align(center)[
  #github-info("moseschmiedel/std-span-talk")
]

#v(1fr)

#focus-slide([
  Which types exist in C++20 to describe a contiguous sequence of objects?
])

#let sources(body) = context {
  _sources_dict.update(
    body,
  )
}


== contiguous sequence types

- ```cpp int[N]``` (C-style array)
  - not much more then a raw pointer
- ```cpp std::array```
  - fixed-size at compile-time
- ```cpp std::vector```
  - dynamic-size
- iterators ```cpp (arr.begin(), arr.end())```
- ```cpp std::ranges::range``` and ```cpp std::ranges::view```
- ...and ```cpp std::span```!

#sources[
  @noauthor_array_nodate
  @noauthor_stdarray_nodate
  @noauthor_stdvector_nodate
  @noauthor_stdrangesrange_nodate
  @noauthor_stdrangesview_nodate
  @noauthor_stdspan_nodate
]


== motivation
#sources[@macintosh_span_2018[p.~6]]
- decoupling from container implementation
- bounds-safety
- type-safety
  - clearer semantic hints for analysis tools then \
    ```cpp struct { size_t len; void* buf; }; ```



== `std::span`

- header `<span>`
```cpp
template<
    class T,
    std::size_t Extent = std::dynamic_extent
> class span;
```
- `Extent` can be
  - ```cpp std::dynamic_extent``` (default)
  - ```cpp constexpr std::size_t``` for static sizes

#sources[
  @noauthor_stdspan_nodate
]
---

- unowned "view" over contiguous sequence of objects starting at position 0
- bounds-safety guarantees

#sources[
  @noauthor_stdspan_nodate
]



== usage

#let simple_function_file = read("examples/simple_function.cpp").split("\n")

#v(1fr)
#raw(
  (
    simple_function_file.at(1),
    "",
    ..simple_function_file.slice(3, 6),
    "",
    ..simple_function_file.slice(7, 9),
  ).join("\n"),
  lang: "cpp",
  block: true,
)
#v(1fr)
#sources[@noauthor_stdspan_nodate]

== construct from `std::vector`, `std::array` and C array
#sources[@noauthor_stdspan_nodate, @noauthor_stdspantextentspan_nodate]

#raw(read("examples/vector.cpp").split("\n").at(0), lang: "cpp", block: true)
#raw(read("examples/array.cpp").split("\n").at(0), lang: "cpp", block: true)
#raw(read("examples/c_array.cpp").split("\n").at(0), lang: "cpp", block: true)

#v(1fr)

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 10pt,
    table.header([*Constructor*], [*Extent*], [*data*]),
    ```cpp std::span{vector}```, ```cpp std::dynamic_extent```, ```cpp [1,2,3,4]```,
    ```cpp std::span{array}```, ```cpp 4```, ```cpp [2,3,4,1]```,
    ```cpp std::span{c_array}```, ```cpp 4```, ```cpp [3,4,1,2]```,
  )
]

#v(1fr)

== construct from iterators
#sources[@noauthor_stdspan_nodate, @noauthor_stdspantextentspan_nodate]
#let it_file = read("examples/iterator.cpp").split("\n")
#raw(it_file.at(0), lang: "cpp", block: true)

#v(1fr)

#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 10pt,
    table.header([*Constructor*], [*Extent*], [*data*]),
    ```cpp std::span{it, 4}```, ```cpp std::dynamic_extent```, ```cpp [3,4,1,2]```,
    ```cpp std::span{it, it+4}```, ```cpp std::dynamic_extent```, ```cpp [3,4,1,2]```,
    ```cpp std::span<int,4>{it,4}```, ```cpp 4```, ```cpp [3,4,1,2]```,
    ```cpp std::span<int,4>{it,it+4}```, ```cpp 4```, ```cpp [3,4,1,2]```,
  )
]

#v(1fr)

== data members
#sources[@noauthor_stdspan_nodate]
```cpp
class span {
  public:
    constexpr std::size_t extent = Extent;
  private:
    T* data_; // pointer to underlying sequence

    // only present when extent == std::dynamic_extent
    std::size_t size_; // number of elements
}
```

== member functions
#sources[@noauthor_stdspan_nodate]

- `operator=`
- *iterators:* `begin`, `end`, `rbegin`, `rend`
- *access:* `front`, `back`, `data`, `operator[]`
  - _C++26:_ `at` checks array bounds before access
- *length:* `size`, `size_bytes`, `empty`
- *subviews:* `first`, `last`, `subspan`

#v(1fr)

#sym.arrow.double.r no methods which change array size!

#v(1fr)

== custom container types

#let my-container-file = read("examples/my_container.cpp").split("\n")

#text(22pt)[
  #raw(
    (
      ..my-container-file.slice(8, 11),
      ..my-container-file.slice(12, 14),
      ..my-container-file.slice(15, 22),
      "...",
    ).join("\n"),
    lang: "cpp",
    block: true,
  )
]

---

#text(22pt)[
  #raw(
    (
      "...",
      ..my-container-file.slice(23, 27),
    ).join("\n"),
    lang: "cpp",
    block: true,
  )
]

---

#text(22pt)[
  #raw(
    (
      ..my-container-file.slice(28, 36),
    ).join("\n"),
    lang: "cpp",
    block: true,
  )
]

==== Output

`[1, 2]`

== demo

example at \
#github-info("moseschmiedel/std-span-talk/tree/main/examples/parallel.cpp")

#v(1fr)

run with
```bash
nix run .#parallel
```
or
```bash
cmake -B build -S examples
cmake --build build
./build/parallel
```

== `std::mdspan`
#sources[@noauthor_stdmdspan_nodate]

- C++23
- header `<mdspan>`
- multidimensional array view
  - maps multidimensional index to array element
  - array does not need to be contiguous

---

#v(1fr)
```cpp
template<
    class T,
    class Extents,
    class LayoutPolicy = std::layout_right,
    class AccessorPolicy = std::default_accessor<T>
> class mdspan;
```
#v(1fr)
#sources[@noauthor_stdmdspan_nodate]

---
#sources[@noauthor_stdmdspan_nodate]

#let mdspan-file = read("examples/mdspan.cpp").split("\n")

#text(22pt)[
  #raw(
    (
      mdspan-file
    ).join("\n"),
    lang: "cpp",
    block: true,
  )
]

== benefits

- small, "zero-cost" abstraction
- builtin safety guarantees
- performance increase for frequently called code paths
- simple answer for the question "Which array type should I use?"

== limitations

- needs contiguous memory
- has fixed size, no resizing possible
- dangling `std::span` possible

== dangling `std::span`

#let dangling-span-file = read("examples/dangling_span.cpp").split("\n")

#text(22pt)[
  #raw(
    (
      dangling-span-file.slice(5)
    ).join("\n"),
    lang: "cpp",
    block: true,
  )
]


== conclusion

#v(1fr)
`std::span` is a *"zero-cost" abstraction*, that enables\ *automatic optimizations* and *trivial passing* of *contiguous* data structures where *no ownership* of the underlying memory is required!
#v(1fr)

== bibliography

#bibliography("C133 - OS \"Modern C++\".bib", title: none)
