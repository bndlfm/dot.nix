{ lib
, python3Packages
, fetchFromGitHub
, tesseract
, poppler-utils
}:

python3Packages.buildPythonApplication rec {
  pname = "nano-pdf";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gavrielc";
    repo = "Nano-PDF";
    rev = "main";
    hash = "sha256-B+FAX8+fvErHiiyLpofnzKpcOTxvU0Q7/PRFcU9YAuA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    typer
    pdf2image
    pypdf
    pytesseract
    google-genai
    python-dotenv
    pillow
  ] ++ [
    tesseract
    poppler-utils
  ];

  pythonImportsCheck = [ "nano_pdf" ];

  meta = with lib; {
    description = "CLI tool to edit PDF slides using natural language prompts";
    homepage = "https://github.com/gavrielc/Nano-PDF";
    license = licenses.mit;
    mainProgram = "nano-pdf";
  };
}
