{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfupdate";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "tfupdate";
    rev = "v${version}";
    sha256 = "sha256-/wkCd73SrspHccbOZV6lq0Htk+Vjgbu2uTZLiEeZAdc=";
  };

  vendorHash = "sha256-/ZNWVuGInZY/t0s317FQstEPeJpTKWMXUVo8cE44GkI=";

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Update version constraints in your Terraform configurations";
    mainProgram = "tfupdate";
    homepage = "https://github.com/minamijoyo/tfupdate";
    changelog = "https://github.com/minamijoyo/tfupdate/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Intuinewin qjoly ];
  };
}
