use std::path::Path;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    // Assume the hack workspace 'fbcode/hphp/hack/src/Cargo.toml'.
    let mut cargo_cmd = Command::new("cargo");
    cargo_cmd.args(&["locate-project", "--workspace", "--message-format=plain"]);
    let output = cargo_cmd.output().unwrap().stdout;
    let hphp = Path::new(std::str::from_utf8(&output).unwrap().trim())
        .ancestors()
        .nth(3)
        .unwrap();
    let fbcode = hphp.parent().unwrap();

    let files = vec![
        PathBuf::from("hhvm_types_ffi.rs"),
        PathBuf::from("as-base-ffi.cpp"),
        PathBuf::from("as-base-ffi.h"),
        hphp.join("runtime/vm/as-base.cpp"),
        hphp.join("runtime/vm/as-base.h"),
    ];

    cxx_build::bridge("hhvm_types_ffi.rs")
        .files(files.iter().filter(is_cpp))
        .include(fbcode)
        .cpp(true)
        .flag("-std=c++17")
        .compile("hhvm_types_ffi");

    files.iter().for_each(rerun_if_changed);
    rerun_if_changed("build.rs");
}

fn rerun_if_changed<P: AsRef<Path>>(f: P) {
    println!("cargo:rerun-if-changed={}", f.as_ref().to_str().unwrap());
}

fn is_cpp<P: AsRef<Path>>(path: &P) -> bool {
    path.as_ref().extension().map_or(false, |e| e == "cpp")
}
