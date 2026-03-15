str = b"a" * 18 + b"\x1C\x01" + b"\x16\x01" + b"\x0D"
with open("hard.bin", "wb") as fl:
    fl.write(str)
