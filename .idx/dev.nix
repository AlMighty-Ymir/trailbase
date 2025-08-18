# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-25.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    # Use toolchain
    pkgs.gcc
    pkgs.glibc.dev
    pkgs.stdenv.cc

    # Rust toolchain  
    pkgs.rustc
    pkgs.cargo

    # Node.js ecosystem  
    pkgs.nodejs_20
    pkgs.nodePackages.pnpm

    # Build dependencies
    pkgs.protobuf
    pkgs.pkg-config
    pkgs.openssl.dev
    pkgs.sqlite.dev
    pkgs.libclang
  ];

  # Sets environment variables in the workspace
  env = {
    # Use target for Rust  
    # CARGO_BUILD_TARGET = "x86_64-unknown-linux";
      
    # specific paths  
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";  
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.sqlite.dev}/lib/pkgconfig";
      
    # OpenSSL configuration
    OPENSSL_DIR = "${pkgs.openssl.dev}";  
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";  
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";  
    # OPENSSL_STATIC = "1";
      
    # Use bundled SQLite  
    LIBSQLITE3_SYS_BUNDLED = "1";
      
    # Bindgen configuration
    BINDGEN_EXTRA_CLANG_ARGS = ''
      -I${pkgs.glibc.dev}/include
      -I${pkgs.glibc.dev}/include/x86_64-unknown-linux-gnu
      -I${pkgs.libclang.lib}/lib/clang/19/include
    '';

    # Compiler settings
    CC = "${pkgs.stdenv.cc}/bin/gcc";  
    CXX = "${pkgs.stdenv.cc}/bin/g++";  
      
    # Static linking should work better  
    # RUSTFLAGS = "-C target-feature=+crt-static";

  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "rust-lang.rust-analyzer"  # Rust language support  
      "tamasfe.even-better-toml" # TOML support for Cargo.toml  
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        # web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
        #   command = ["npm" "run" "dev"];
        #   manager = "web";
        #   env = {
        #     # Environment variables to set for your server
        #     PORT = "$PORT";
        #   };
        # };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Example: install JS dependencies from NPM
        # npm-install = "npm install";
      };
      # Runs when the workspace is (re)started
      onStart = {
        # Example: start a background task to watch and re-build backend code
        # watch-backend = "npm run watch-backend";
      };
    };
  };
}
