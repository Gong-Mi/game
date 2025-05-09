cmake_minimum_required(VERSION 3.22.1) # 与 app/build.gradle 中指定的版本一致

# 添加你的原生库
# 替换 native_vulkan_app 为你的库名称
# 替换 main.cpp 和 vulkan_renderer.cpp 为你的原生源文件
add_library( native_vulkan_app # Sets the name of the library.
             SHARED # Builds a shared library.
             main.cpp vulkan_renderer.cpp # Add your native source files here.
             )

# 查找并链接 Android 和 log 库
find_library( # Sets the name of the path variable.
              log-lib
              log )

# 查找 Vulkan 库 (需要 NDK 支持 Vulkan)
# Android NDK >= r12 支持 Vulkan
find_package(Vulkan REQUIRED) # 查找 Vulkan 开发文件

# 链接你的库到找到的库
target_link_libraries( # Specifies the target library.
                       native_vulkan_app

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib}

                       # 链接 Vulkan 库
                       ${Vulkan_LIBRARIES}

                       # 其他你需要的库，例如 Android
                       android
                       )

# (可选) 配置着色器编译，如果你的着色器不是预编译的 SPIR-V
# 需要 find_program(GLSLANG_VALIDATOR_EXECUTABLE glslangValidator)
# 然后 add_custom_command 来编译着色器，并确保它们被打包到 assets
# 这部分比较复杂，先省略

# (可选) 将编译好的 SPIR-V 等资源复制到 Gradle 可以打包的 assets 目录
# 例如:
# file(COPY ${CMAKE_BINARY_DIR}/shaders DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../assets)
# 需要确保在 app/build.gradle 的 packagingOptions 中指向这个目录
