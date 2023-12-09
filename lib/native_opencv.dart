import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
// ignore_for_file: camel_case_types

// C function signatures
typedef _version_func = ffi.Pointer<Utf8> Function();
typedef _process_image_func = ffi.Void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _is_invert_needed_func = ffi.Bool Function(ffi.Pointer<Utf8>);
typedef _invert_image_func = ffi.Void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _ProcessImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);
typedef _IsInvertNeededFunc = bool Function(ffi.Pointer<Utf8>);
typedef _InvertImage = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
    ? ffi.DynamicLibrary.open('libnative_opencv.so')
    : ffi.DynamicLibrary.process();

// Looking for the functions
final _VersionFunc _version =
    _lib.lookup<ffi.NativeFunction<_version_func>>('version').asFunction();
final _ProcessImageFunc _processImage = _lib
    .lookup<ffi.NativeFunction<_process_image_func>>('process_image')
    .asFunction();
final _IsInvertNeededFunc _isInvertNeeded = _lib
    .lookup<ffi.NativeFunction<_is_invert_needed_func>>('is_invert_needed')
    .asFunction();
final _InvertImage _invertImage = _lib
    .lookup<ffi.NativeFunction<_invert_image_func>>('invert_image')
    .asFunction();

String opencvVersion() {
  return _version.toString();
}

void processImage(String inputPath, String outputPath) {
  _processImage(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
}

bool isInvertNeeded(String inputPath) {
  return _isInvertNeeded(inputPath.toNativeUtf8());
}

void invertImage(String inputPath, String outputPath) {
  _invertImage(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
}
