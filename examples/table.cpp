void table_limit() {
    std::string dashes_l(WIDTH_L + 2, '-');
    std::string dashes_c(WIDTH_C + 2, '-');
    std::string dashes_r(WIDTH_R + 2, '-');
    std::println("+{}+{}+{}+", dashes_l, dashes_c, dashes_r);
}

void table_header(std::string title_l, std::string title_c, std::string title_r) {
    std::string dashes_l(WIDTH_L + 2, '=');
    std::string dashes_c(WIDTH_C + 2, '=');
    std::string dashes_r(WIDTH_R + 2, '=');
    std::string spaces_l(WIDTH_L - title_l.size(), ' ');
    std::string spaces_r(WIDTH_R - title_r.size(), ' ');
    std::string spaces_c(WIDTH_C - title_c.size(), ' ');

    std::println("| {}{} | {}{} | {}{} |", title_l, spaces_l, title_c, spaces_c, title_r, spaces_r);
    std::println("+{}+{}+{}+", dashes_l, dashes_c, dashes_r);
}