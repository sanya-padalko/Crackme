str = b"a" * 65000 + b"\x0D"
with open("easy.bin", "wb") as fl:
    fl.write(str)
