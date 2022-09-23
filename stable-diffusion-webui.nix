{ nixpkgs, system, ... }:

let
  pkgs = import nixpkgs {
    config.allowUnfree = true;
    system = system;
    overlays = [
      (final: prev: {
        python3 = prev.python3.override {
          packageOverrides = python-self: python-super: {
            pytorch = python-super.pytorch.override { cudaSupport= true; };
          };
        };
      })
    ];
  };
  inherit (pkgs) lib;

  python = pkgs.python3;
  ps = python.pkgs;
in
pkgs.mkShell {
  packages = [
    pkgs.cudatoolkit
    python

    # From conda-forge
    ps.pytorch
    ps.torchvision
    ps.numpy

    # Pip
    ps.opencv4
    ps.pudb
    ps.imageio
    ps.imageio-ffmpeg
    ps.pytorch-lightning
    ps.omegaconf
    ps.test-tube
    ps.einops
    ps.transformers
    ps.torchmetrics
    ps.pynvml
    
    pkgs.streamlit
    ps.gradio
    ps.albumentations
    ps.torch-fidelity
    ps.kornia
    ps.imwatermark
    ps.taming-transformers
    ps.k-diffusion
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
  ];

  # shellHook = ''
  #   python3 -m venv venv
  #   . venv/bin/activate
  # '';
}
