import bbd


proc runDownload*(install_path: string): int =
  discard download(package = "HELICS", install_path = install_path)
  return 0
