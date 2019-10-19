#include <iostream>
#include <cstddef>

#include <boost/gil/image.hpp>
#include <boost/gil/image_view.hpp>
#include <boost/gil/typedefs.hpp>

namespace gil = boost::gil;

// namespace cuda
// {
// // view_type_from_pixel<Pixel, IsPlanar = false>::type
// // iterator_type_from_pixe<Pixel, IsPlanar = false, IsStep = false, bool  IsMutable = false> = Pixel*, const version is const Pixel*
// // type_from_x_iterator<Pixel*> = {step_iterator_t = memory_based_step_iterator<Pixel*> xy_locator_t = memory_based_2d_locator<step_iterator_t>}

//     template <typename Pixel>
//     class memory_based_step_iterator 
//     {
//     private:
        
//     };

//     template <typename Pixel>
//     class buffer_view 
//     {
//         using value_type = Pixel;
//         using reference = value_type&;
        
//     };

//     template <typename Pixel>
//     class image_buffer 
//     {
//         using point_t = gil::point_t;

//         template <typename View>
//         image_buffer(View view) 
//         {
//             const auto dimensions = view.dimensions();
//         }

//     private:
//         unsigned char* memory;
//         std::size_t allocated_bytes;
//     };
// }

template <typename View>
__global__ void check_pixels(View view) {
    std::ptrdiff_t x = blockIdx.x * blockDim.x + threadIdx.x;
    std::ptrdiff_t y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x >= view.width() || y >= view.height()) {
        return;
    }

    view(x, y) *= 2;
}

int main() {
    std::cout << "hello\n";
    using pixel = gil::rgb8_pixel_t;
    pixel* contents = nullptr;
    std::size_t size = 1920 * 1080;
    cudaMalloc(&contents, sizeof(pixel) * size);
    cudaMemset(contents, 100, sizeof(pixel) * size);
    auto buffer_view = gil::interleaved_view(1920, 1080, contents, 1920);

    auto deref = [](pixel& p) -> decltype(auto) {
        return p.at(std::integral_constant<int, 0>{});
    };
//    auto view = gil::rgb8_view_t::add_deref<decltype(deref)>::make(buffer_view, deref);
//    std::cout << view(0, 0);
}