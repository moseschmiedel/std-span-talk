#import "@preview/touying:0.6.1": *
#import themes.simple: *

#set text(font: "Source Sans Pro")

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
  ]
)

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
1. motivation
2. usage
3. implementation
4. ownership
5. additions after C++20

#focus-slide([
  Which types exist in C++20 to describe a contiguous sequence of objects?
])

#let sources(body) = context {
  _sources_dict.update(
    body
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
- ...and now ```cpp std::span```!

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

- defined in header `<span>`
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
- pointers, iterators and references to elements of a span are invalidated when an operation invalidates a pointer in the range of the span:

#align(center)[
  ```cpp
  [span.data(), span.data() + span.size()]
  ```
]

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
    "",
    ..simple_function_file.slice(5,8)
  ).join("\n"),
  lang: "cpp", 
  block: true)
#v(1fr)
#sources[@noauthor_stdspan_nodate]

== construct from `std::vector`, `std::array` and C array
#sources[@noauthor_stdspan_nodate]
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
    ```cpp std::span{c_array}```, ```cpp 4```, ```cpp [3,4,1,2]```
  )
]

#v(1fr)

== construct from iterators
#sources[@noauthor_stdspan_nodate]
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

- how can my container class get converted to a `std::span`? 

== deduction of `Extent`

== assembly

== available methods

== pointer invalidation (ownership)

== additions after C++20

== `std::spanstream`

== `std::mdspan`

== bibliography

#bibliography("C133 - OS \"Modern C++\".bib", title: "")
