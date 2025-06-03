#include <cstdlib>
#include <cstring>
#include <span>
#include <print>

class MyContainer {
    public:
        std::size_t size;
    private:
        int* array_;
    public:
    MyContainer(std::size_t s, int arr[s]): size(s) {
        array_ = new int[s];
        memcpy(array_, arr, s);
    }

    using iterator = int*;
    iterator begin() {
        return this->array_;
    }
    iterator end() {
        return this->array_ + this->size;
    }
};

int main() {
    int arr[] = {1,2};
    auto m = MyContainer{2, arr};
    auto s = std::span{m};

    std::println("{}", s);

    return EXIT_SUCCESS;
}