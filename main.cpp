#include <iostream>

#include <boost/gil/image.hpp>
#include <boost/gil/typedefs.hpp>
#include <boost/gil/io/read_image.hpp>
#include <boost/gil/io/write_view.hpp>
#include <boost/gil/extension/io/png.hpp>
#include <boost/gil/extension/io/jpeg.hpp>

namespace gil = boost::gil;

int main() {
    std::cout << "hello\n";
    gil::gray8_image_t image;
    gil::read_image("input.png", image, gil::png_tag{});
    std::cout << image.dimensions().x << ' ' << image.dimensions().y << '\n';

    gil::write_view("output.png", gil::view(image), gil::png_tag{});
}