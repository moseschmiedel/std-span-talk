#include <cstdlib>
#include <cstring>
#include <span>
#include <print>
#include <vector>

class MyContainer {
    public:
        std::size_t size;
    private:
        std::vector<int> vector_;
    public:
    MyContainer(std::size_t s, int arr[s]) {
        vector_ = std::vector<int>();
        for (int idx = 0; idx < s; idx++) {
            vector_.emplace(vector_.end(), arr[idx]);
        }
    }

    using iterator = std::vector<int>::iterator;
    iterator begin() {
        return this->vector_.begin();
    }
    iterator end() {
        return this->vector_.end();
    }
};

int main() {
    int arr[] = {1,2};
    auto m = MyContainer{2, arr};
    auto s = std::span{m};

    std::println("{}", s);

    return EXIT_SUCCESS;
}