int* it = c_array;
info("std::span{it, 4}", std::span{it, 4});
info("std::span{it, it+4}", std::span{it, it+4});
info("std::span<int,4>{it, 4}" , std::span<int,4>{it, 4});
info("std::span<int,4>{it,it+4}", std::span<int,4>{it,it+4});
