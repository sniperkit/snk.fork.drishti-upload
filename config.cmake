message(">:>:>:>:>:>:>:>:>:>:>:>:>:>:>:>:>: ${CMAKE_MODULE_PATH} <:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:<:")

string(COMPARE EQUAL "${CMAKE_SYSTEM_NAME}" "Linux" is_linux)

message("-- config.cmake --")
message("  MSVC: ${MSVC}")
message("  APPLE: ${APPLE}")
message("  ANDROID: ${ANDROID}")
message("  IOS: ${IOS}")
message("  is_linux: ${is_linux}")
message("  XCODE: ${XCODE}")

### OpenCV
if(ANDROID)
  message("ANDROID ========================================================================")
  include(drishti_set_opencv_cmake_args_android)
  drishti_set_opencv_cmake_args_android()
  list(
      APPEND OPENCV_CMAKE_ARGS
      ENABLE_NEON=ON
      WITH_AVFOUNDATION=OFF   # "Use AVFoundation for Video I/O"
      WITH_DSHOW=OFF          # "Build VideoIO with DirectShow support"
      WITH_JASPER=OFF         # "Include JPEG2K support"
      WITH_JPEG=OFF           # "Include JPEG support"
      WITH_LIBV4L=OFF         # "Use libv4l for Video 4 Linux support"
      WITH_PTHREADS_PF=ON     # "Use pthreads-based parallel_for"
      WITH_TBB=OFF            # "Include Intel TBB support"
      WITH_V4L=OFF            # "Include Video 4 Linux support"
      WITH_VFW=OFF            # "Include Video for Windows support"
  )
elseif(IOS)
  message("IOS ============================================================================")
  include(drishti_set_opencv_cmake_args_ios)
  drishti_set_opencv_cmake_args_ios()
  list(
      APPEND OPENCV_CMAKE_ARGS
      ENABLE_NEON=ON
      WITH_AVFOUNDATION=OFF   # "Use AVFoundation for Video I/O"
      WITH_DSHOW=OFF          # "Build VideoIO with DirectShow support"
      WITH_JASPER=OFF         # "Include JPEG2K support"
      WITH_JPEG=OFF           # "Include JPEG support"
      WITH_LIBV4L=OFF         # "Use libv4l for Video 4 Linux support"
      WITH_PTHREADS_PF=OFF     # "Use pthreads-based parallel_for"
      WITH_TBB=OFF            # "Include Intel TBB support"
      WITH_V4L=OFF            # "Include Video 4 Linux support"
      WITH_VFW=OFF            # "Include Video for Windows support"
  )
elseif(APPLE)
  message("APPLE ==========================================================================")
  include(drishti_set_opencv_cmake_args_osx)
  drishti_set_opencv_cmake_args_osx()
  list(
      APPEND OPENCV_CMAKE_ARGS
      BUILD_JPEG=OFF ## HUNTER
      ENABLE_NEON=OFF
      HAVE_CUBLAS=NO
      HAVE_CUDA=NO
      HAVE_CUFFT=NO
      HAVE_EIGEN=NO
      HAVE_OPENCL=NO
      WITH_AVFOUNDATION=ON    # "Use AVFoundation for Video I/O"
      WITH_DSHOW=OFF          # "Build VideoIO with DirectShow support"
      WITH_JASPER=ON          # "Include JPEG2K support"
      WITH_JPEG=ON            # "Include JPEG support"
      WITH_LIBV4L=OFF         # "Use libv4l for Video 4 Linux support"
      WITH_OPENCL=NO
      WITH_PTHREADS_PF=OFF    # "Use pthreads-based parallel_for"
      WITH_QTKIT=NO
      WITH_TBB=OFF            # "Include Intel TBB support"
      WITH_V4L=OFF            # "Include Video 4 Linux support"
      WITH_VFW=OFF            # "Include Video for Windows support"
  )
elseif(${is_linux})
  message("is_linux =======================================================================")
  include(drishti_set_opencv_cmake_args_nix)
  drishti_set_opencv_cmake_args_nix()
elseif(MSVC)
  message("MSVC ===========================================================================")
  include(drishti_set_opencv_cmake_args_windows)
  drishti_set_opencv_cmake_args_windows()
endif()

option(DRISHTI_BUILD_OGLES_GPGPU "Build with OGLES_GPGPU" ON)
option(DRISHTI_BUILD_ACF "Drishti ACF lib" ON)
option(DRISHTI_OPENGL_ES3 "Support OpenGL ES 3.0 (default 2.0)" OFF)
option(DRISHTI_BUILD_MIN_SIZE "Build minimum size lib (exclude training)" ON)
option(DRISHTI_BUILD_OPENCV_WORLD "Build OpenCV world (monolithic lib)" ON)
option(DRISHTI_SERIALIZE_WITH_CVMATIO "Perform serialization with cvmatio" OFF)

list(APPEND OPENCV_CMAKE_ARGS
  BUILD_opencv_world=${DRISHTI_BUILD_OPENCV_WORLD}
  BUILD_opencv_ts=OFF
  BUILD_opencv_python2=OFF
  BUILD_opencv_shape=OFF
  BUILD_opencv_superres=OFF
  HAVE_OPENCL=OFF
  WITH_OPENCL=OFF
  BUILD_EIGEN=OFF  ### for convenient linking
  BUILD_SHARED_LIBS=OFF
)

set(dlib_cmake_args
  DLIB_HEADER_ONLY=OFF  #all previous builds were header on, so that is the default
  DLIB_ENABLE_ASSERTS=OFF #must be set on/off or debug/release build will differ and config will not match one
  DLIB_NO_GUI_SUPPORT=ON
  DLIB_ISO_CPP_ONLY=OFF # needed for directory navigation code (loading training data)
  DLIB_JPEG_SUPPORT=OFF  # https://github.com/hunter-packages/dlib/blob/eb79843227d0be45e1efa68ef9cc6cc187338c8e/dlib/CMakeLists.txt#L422-L432
  DLIB_LINK_WITH_SQLITE3=OFF
  DLIB_USE_BLAS=OFF
  DLIB_USE_LAPACK=OFF
  DLIB_USE_CUDA=OFF
  DLIB_PNG_SUPPORT=ON
  DLIB_GIF_SUPPORT=OFF
  DLIB_USE_MKL_FFT=OFF
  HUNTER_INSTALL_LICENSE_FILES=dlib/LICENSE.txt
  )

# Maintain hunter default args (no testing, license name) and eliminate
# eigen fortrn dependencies
set(EIGEN_CMAKE_ARGS
  BUILD_TESTING=OFF
  HUNTER_INSTALL_LICENSE_FILES=COPYING.MPL2
  CMAKE_Fortran_COMPILER=OFF
)

### Set xgboost args ###
set(XGBOOST_CMAKE_ARGS
  XGBOOST_USE_CEREAL=ON
  XGBOOST_USE_HALF=ON
  )

option(DRISHTI_ACF_AS_SUBMODULE "Use ACF as a submodule" OFF)

set(acf_cmake_args
  ACF_BUILD_OGLES_GPGPU=ON
  ACF_BUILD_TESTS=OFF
  ACF_BUILD_EXAMPLES=OFF
  ACF_SERIALIZE_WITH_CVMATIO=${DRISHTI_SERIALIZE_WITH_CVMATIO}
  ACF_SERIALIZE_WITH_CEREAL=ON
  ACF_BUILD_OGLES_GPGPU=${DRISHTI_BUILD_OGLES_GPGPU}
)

if(DRISHTI_BUILD_MIN_SIZE)
  list(APPEND XGBOOST_CMAKE_ARGS XGBOOST_DO_LEAN=ON)
else()
  list(APPEND XGBOOST_CMAKE_ARGS XGBOOST_DO_LEAN=OFF)
endif()

### Toggle OpenGL ES 3.0 ###
if(DRISHTI_OPENGL_ES3)
  set(use_opengl_es3 ON)
else()
  set(use_opengl_es3 OFF)
endif()

set(OGLES_GPGPU_CMAKE_ARGS
  OGLES_GPGPU_VERBOSE=OFF
  OGLES_GPGPU_OPENGL_ES3=${use_opengl_es3}
)

set(AGLET_CMAKE_ARGS AGLET_OPENGL_ES3=${use_opengl_es3})

hunter_config(ARM_NEON_2_x86_SSE VERSION 1.0.0-p0)
hunter_config(Eigen VERSION 3.3.1-p4 CMAKE_ARGS ${EIGEN_CMAKE_ARGS})
hunter_config(GTest VERSION 1.8.0-hunter-p11)
hunter_config(Jpeg VERSION 9b-p3)
hunter_config(OpenCV VERSION 3.4.1-p1 CMAKE_ARGS "${OPENCV_CMAKE_ARGS}")
hunter_config(PNG VERSION 1.6.26-p1)

set(qt_cmake_args "")
if(is_linux OR MINGW)
  set(qt_version 5.5.1-cvpixelbuffer-2-p9)
else()
  set(qt_version 5.9.1-p0)
endif()

if(MSVC)
  list(APPEND qt_cmake_args QT_OPENGL_DESKTOP=ON)
endif()

if(is_linux)
  list(APPEND qt_cmake_args BUILD_SHARED_LIBS=ON QT_WITH_GSTREAMER=ON)
endif()

hunter_config(Qt VERSION ${qt_version} CMAKE_ARGS ${qt_cmake_args})

hunter_config(RapidXML VERSION 1.13)
hunter_config(aglet VERSION ${HUNTER_aglet_VERSION} CMAKE_ARGS ${AGLET_CMAKE_ARGS}) # test only, use latest
hunter_config(cereal VERSION 1.2.2-p0)
hunter_config(cvmatio VERSION 1.0.28)
hunter_config(dlib VERSION ${HUNTER_dlib_VERSION} CMAKE_ARGS ${dlib_cmake_args})
hunter_config(drishti_assets VERSION 1.8)
hunter_config(drishti_faces VERSION 1.2)
hunter_config(eigen3-nnls VERSION 1.0.1) # eos
hunter_config(eos VERSION 0.12.1) # eos
hunter_config(glfw VERSION 3.3.0-p4)
hunter_config(glm VERSION 0.9.8.5) # eos
hunter_config(half VERSION 1.1.0-p1)
hunter_config(nanoflann VERSION 1.2.3-p0) # eos
hunter_config(ogles_gpgpu VERSION ${HUNTER_ogles_gpgpu_VERSION} CMAKE_ARGS ${OGLES_GPGPU_CMAKE_ARGS})
hunter_config(spdlog VERSION 0.13.0-p0)
hunter_config(sse2neon VERSION 1.0.0-p0)
hunter_config(thread-pool-cpp VERSION 1.1.0)
hunter_config(xgboost VERSION 0.40-p10 CMAKE_ARGS ${XGBOOST_CMAKE_ARGS})

if(DRISHTI_ACF_AS_SUBMODULE)
  if(NOT DRISHTI_UPLOAD_IGNORE_SUBMODULES)
    hunter_config(acf GIT_SUBMODULE "src/3rdparty/acf" CMAKE_ARGS ${acf_cmake_args})
  endif()
else()
# ACF from direct URL:
  set(acf_url "https://github.com/elucideye/acf/archive/v0.1.12.tar.gz")
  set(acf_sha1 "f0ee6ba5dfd9655bfd529d335e32750db7e68c3b")
  hunter_config(acf URL ${acf_url} SHA1 ${acf_sha1}  CMAKE_ARGS ${acf_cmake_args})
# ACF from Hunter
#  hunter_config(acf VERSION ${HUNTER_acf_VERSION} CMAKE_ARGS ${acf_cmake_args})
endif()

# experimental: lock verison but not used for CI builds
hunter_config(dest VERSION 0.8.0-p4)
hunter_config(flatbuffers VERSION 1.8.0-p1)
hunter_config(tinydir VERSION 1.2-p0)
hunter_config(Beast VERSION 1.0.0-b32-hunter-4)

if(NOT DRISHTI_UPLOAD_IGNORE_SUBMODULES)

  # Note: MSVC currently broken due to internal GL_BGR(A) enums
  # TODO: Update imshow package
  if(NOT (ANDROID OR IOS OR MSVC))
    hunter_config(imshow GIT_SUBMODULE "src/3rdparty/imshow")
  endif()
endif()

# Requirements for Urho3D {

# * https://docs.hunter.sh/en/latest/packages/pkg/Urho3D.html
hunter_config(Lua VERSION 5.1.5-p3)
hunter_config(SDL2 VERSION 2.0.4-urho-p4)

# }

# FIXME, waiting for release:
# * https://github.com/jarro2783/cxxopts/issues/110#issuecomment-394909564
hunter_config(
    cxxopts
    VERSION 2.1.1
    URL https://github.com/jarro2783/cxxopts/archive/e725ea308468ab50751ba7f930842a4c061226e9.zip
    SHA1 cbeec5576599d031f6f992d987e1f3575b3afee3
)
