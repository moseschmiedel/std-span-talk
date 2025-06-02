#import "@preview/touying:0.6.1": *
#import themes.simple: *

#set text(font: "Source Sans Pro")

#let title = [`std::span`]
#let subtitle = [presentation for the course "C133 - OS Modern C++"]
#let author = [Mose Schmiedel]
#let date = datetime.today()
#let institution = [HTWK Leipzig \ University of Applied Sciences Leipzig]
#let logo = image("assets/HTWK_Zusatz_de_H_Black_sRGB.svg")

#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: title,
    subtitle: subtitle,
    author: author,
    date: date,
    institution: institution,
    logo: logo,
  )
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

== motivation

== `std::span` #footnote[@noauthor_stdspan_nodate]

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

---

- unowned "view" over contiguous sequence of objects starting at position 0
- bounds-safety guarantees
- pointers, iterators and references to elements of a span are invalidated when an operation invalidates a pointer in the range of the span:

#align(center)[
  ```cpp
  [span.data(), span.data() + span.size()]
  ```
]

== usage

#let simple_function_file = read("examples/simple_function.cpp").split("\n")

#v(1fr)
#raw(
  (
    simple_function_file.at(1),
    "",
    ..simple_function_file.slice(5,7)
  ).join("\n"),
  lang: "cpp", 
  block: true)
#v(1fr)

== construct from `std::vector`
#raw(read("examples/vector.cpp"), lang: "cpp", block: true)

== construct from `std::array`
#raw(read("examples/array.cpp"), lang: "cpp", block: true)

== construct from C-style array
#raw(read("examples/c_array.cpp"), lang: "cpp", block: true)

== construct from iterators
#raw(read("examples/iterator.cpp"), lang: "cpp", block: true)


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
