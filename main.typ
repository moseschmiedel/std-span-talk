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
#outline()

#focus-slide([
  Which types exist in C++20 to describe a contiguous sequence of objects?
])

== contiguous sequence types

- ```cpp int[N]```
  - not much more then a raw pointer
  - can also be declared with ```cpp new int[N]``` for storing in the heap
- ```cpp std::array```
  - fixed-size at compile-time
- ```cpp std::vector```
  - dynamic-size
- ```cpp std::span```

== `std::span` #footnote[@noauthor_stdspan_nodate]

- defined in header `<span>`
```cpp
template<
    class T,
    std::size_t Extent = std::dynamic_extent
> class span;
```
- `Extent` can be
  - `std::dynamic_extent` (default)
  - `std::static_extent`

---

- unowned "view" over contiguous sequence of objects starting at position 0
- bounds-safety guarantees
- pointers, iterators and references to elements of a span are invalidated when an operation invalidates a pointer in the range of the span:

#align(center)[
  ```cpp
  [span.data(), span.data() + span.size()]
  ```
]

== motivation

== usage

#raw(read("examples/usage.cpp"), lang: "cpp", block: true)

== pointer invalidation

== assembly

== outlook

== `std::spanstream`

== `std::mdspan`

== bibliography

#bibliography("C133 - OS \"Modern C++\".bib", title: "")
