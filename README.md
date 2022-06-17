# xor_d

> Vince Codispot | tsrvinnie@gmail.com
<p><br />
XOR Decyption Tool that accepts an input file(-f) and a hex XOR decryption key(-k) with options to adjust the infile offset(-s), number of bytes(-b) XOR decrypted per iteration(1-4), a hex number for incrementing the XOR decryption key(-i) per iteration, and a hex number for incrementing the Part of the file being XOR decrypted(-p) per iteration. Option (-a) can be used to add a hex number to the part incremement each iteration.
<br />
<br /></p>

```
Syntax: xor_d.sh [-f Input_File] [-b Number_of_Bytes] [-k XOR_Key] [-i XOR_Key_Increment] [-o Outfile]

options:
a Part Incremement Addition. Optional Hex value to increment the Part Increment value each iteration.
b Decimal number of Bytes (Part) to XOR Decrypt per Iteration. If left empty, the tool will XOR Decrypt 4 bytes(DWORD) with same XOR Decryption Key per iteration.
f Input Filename.
h Print this Help.
i XOR Decryption Key Increment. Hex number for incrementing the XOR Decryption Key per iteration. Default is zero.
k XOR Decryption Key. If left empty the tool will use the last 4 Bytes from the input file as the XOR Decyption Key. Enter in Hex.
o Output Filename.
p Part Increment. Hex number for incrementing the Part of the file being XOR decrypted per iteration. Default is zero.
s Start Bytes. Decimal number for infile offset. Default is zero.
x Preview x Number Bytes of Decrypted Data.
```

## Examples:
<p>
Run xor_d against file "rcdata.bin" using XOR Key 0008a5ac to decrypt four bytes per iteration, with each iteration incrementing the XOR Key by four. Option (-a) is used to incremenent the Part Increment (-p) by four each iteration. The Part Increment (-p) is 4. This means that the second set of four bytes will be incremented by four before being XOR decrypted, and then the third set of four bytes will be incremented by eight before being XOR decrypted, etc.</p>

```
./xor_d.sh -f ./rcdata.bin -b 4 -i 4 -p 4 -s 4 -k 0008a5ac -a 4 -o outfile_test.bin
```
