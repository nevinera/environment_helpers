D = Steep::Diagnostic

target :lib do
  signature "sig"
  check "lib"
  configure_code_diagnostics(D::Ruby.default)
  library "pathname"
  library "date"
end

target :test do
  signature "sig"
  check "test"
  configure_code_diagnostics(D::Ruby.default)
  library "pathname"
  library "date"
end
