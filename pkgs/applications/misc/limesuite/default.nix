{ stdenv, fetchFromGitHub, cmake
, sqlite, wxGTK30, libusb1, soapysdr
, mesa_glu, libX11, gnuplot, fltk
} :

let
  version = "18.04.1";

in stdenv.mkDerivation {
  name = "limesuite-${version}";

  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuite";
    rev = "v${version}";
    sha256 = "1aaqnwif1j045hvj011k5dyqxgxx72h33r4al74h5f8al81zvzj9";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libusb1
    sqlite
    wxGTK30
    fltk
    gnuplot
    libusb1
    soapysdr
    mesa_glu
    libX11
  ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp ../udev-rules/64-limesuite.rules $out/lib/udev/rules.d

    mkdir -p $out/share/limesuite
    cp bin/Release/lms7suite_mcu/* $out/share/limesuite

    cp bin/dualRXTX $out/bin
    cp bin/basicRX $out/bin
    cp bin/singleRX $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Driver and GUI for LMS7002M-based SDR platforms";
    homepage = https://github.com/myriadrf/LimeSuite;
    license = licenses.asl20;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

