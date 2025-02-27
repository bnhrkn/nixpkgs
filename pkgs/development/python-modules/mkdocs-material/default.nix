{ lib, callPackage, buildPythonApplication, fetchFromGitHub
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, pygments
, pymdown-extensions
}:

buildPythonApplication rec {
  pname = "mkdocs-material";
  version = "8.2.9";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = version;
    sha256 = "sha256-lrklTQWWsP1rjixqu5/S7XMN+K095NRGv3JkjRQ4brM=";
  };

  propagatedBuildInputs = [
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    pygments
    pymdown-extensions
  ];

  # No tests for python
  doCheck = false;

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "Material for mkdocs";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
