{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, boost
, cgal_5
, eigen
, flann
, gdal
, gmp
, LASzip
, mpfr
, pdal
, pcl
, qtbase
, qtsvg
, qttools
, tbb
, xercesc
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "cloudcompare";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "CloudCompare";
    repo = "CloudCompare";
    rev = "v${version}";
    sha256 = "sha256-hu3ckVocExi9lvxelHAwKb/MZacH4CcCE+vIzElgP/A=";
    fetchSubmodules = true;
  };

  patches = [
    # fix issues compiling on aarch64. remove once upgraded past 2.12.0
    (fetchpatch {
      url = "https://github.com/CloudCompare/CloudCompare/commit/7e71861fdbd6ea704add5ba69343f47d8fc3d5ae.patch";
      sha256 = "sha256-CRUPjxtKUbsqOyYsjKF+dRZ+E3rqrv5mS3ZaOay2wk8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    eigen # header-only
    wrapGAppsHook
  ];

  buildInputs = [
    boost
    cgal_5
    flann
    gdal
    gmp
    LASzip
    mpfr
    pdal
    pcl
    qtbase
    qtsvg
    qttools
    tbb
    xercesc
  ];

  cmakeFlags = [
    "-DCCCORELIB_USE_TBB=ON"
    "-DOPTION_USE_DXF_LIB=ON"
    "-DOPTION_USE_GDAL=ON"
    "-DOPTION_USE_SHAPE_LIB=ON"

    "-DPLUGIN_GL_QEDL=ON"
    "-DPLUGIN_GL_QSSAO=ON"

    "-DPLUGIN_IO_QADDITIONAL=ON"
    "-DPLUGIN_IO_QCORE=ON"
    "-DPLUGIN_IO_QCSV_MATRIX=ON"
    "-DPLUGIN_IO_QE57=ON"
    "-DPLUGIN_IO_QFBX=OFF" # Autodesk FBX SDK is gratis+proprietary; not packaged in nixpkgs
    "-DPLUGIN_IO_QPDAL=ON" # required for .las/.laz support
    "-DPLUGIN_IO_QPHOTOSCAN=ON"
    "-DPLUGIN_IO_QRDB=OFF" # Riegl rdblib is proprietary; not packaged in nixpkgs

    "-DCCCORELIB_USE_CGAL=ON" # enables Delauney triangulation support
    "-DPLUGIN_STANDARD_QPCL=ON" # Adds PCD import and export support
    "-DPLUGIN_STANDARD_QANIMATION=ON"
    "-DPLUGIN_STANDARD_QBROOM=ON"
    "-DPLUGIN_STANDARD_QCANUPO=ON"
    "-DPLUGIN_STANDARD_QCOMPASS=ON"
    "-DPLUGIN_STANDARD_QCSF=ON"
    "-DPLUGIN_STANDARD_QFACETS=ON"
    "-DPLUGIN_STANDARD_QHOUGH_NORMALS=ON"
    "-DEIGEN_ROOT_DIR=${eigen}/include/eigen3" # needed for hough normals
    "-DPLUGIN_STANDARD_QHPR=ON"
    "-DPLUGIN_STANDARD_QM3C2=ON"
    "-DPLUGIN_STANDARD_QMPLANE=ON"
    "-DPLUGIN_STANDARD_QPOISSON_RECON=ON"
    "-DPLUGIN_STANDARD_QRANSAC_SD=ON"
    "-DPLUGIN_STANDARD_QSRA=ON"
    "-DPLUGIN_STANDARD_QCLOUDLAYERS=ON"
  ];

  dontWrapGApps = true;

  # fix file dialogs crashing on non-NixOS (and avoid double wrapping)
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "3D point cloud and mesh processing software";
    homepage = "https://cloudcompare.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nh2 ];
    platforms = with platforms; linux; # only tested here; might work on others
  };
}
