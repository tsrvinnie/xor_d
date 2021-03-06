# xor_d

> Vince Codispot | tsrvinnie@gmail.com
<p><br />
XOR Decyption Tool that accepts an input file(-f) and a hex XOR decryption key(-k) with options to adjust the infile offset(-s), number of bytes(-b) XOR decrypted per iteration(1-4), a hex number for incrementing the XOR decryption key(-i) per iteration, and a hex number for incrementing the Part of the file being XOR decrypted(-p) per iteration.
<br /></p>

```
Syntax: xor_d.sh [-f Input_File] [-b Number_of_Bytes] [-k XOR_Key] [-i XOR_Key_Increment] [-o Outfile | -x Preview_Number_of_Bytes]

options:
-b Decimal number of Bytes (Part) to XOR Decrypt per Iteration. If left empty, the tool will XOR Decrypt 4 bytes(DWORD) with same XOR Decryption Key per iteration.
-f Input Filename.
-h Print this Help.
-i XOR Decryption Key Increment. Hex number for incrementing the XOR Decryption Key per iteration. Default is zero.
-k XOR Decryption Key. If left empty the tool will use the last 4 Bytes from the input file as the XOR Decyption Key. Enter in Hex.
-o Output Filename.
-p Part Increment. Hex number for incrementing the Part of the file being XOR decrypted per iteration. Default is zero.
-s Start Bytes. Decimal number for infile offset. Default is zero.
-x Preview x Number Bytes of Decrypted Data.
```
## Prerequisites - Install xortool and xxd

xortool.py - A tool to do some xor analysis

### Installation
```
$ pip3 install xortool
```

xortool [GitHub Page](https://github.com/hellman/xortool#xortoolpy).

## Examples:
<p>
1.
Run xor_d against file "rcdata.bin" using XOR Key 0008a5ac to decrypt four bytes per iteration, starting four bytes in (-s), with each iteration incrementing the XOR Key by four. The Part Increment (-p) is 4. This means that the second set of four bytes will be incremented by four before being XOR decrypted, and then the third set of four bytes will be incremented by eight before being XOR decrypted, etc.</p>

```
./xor_d.sh -f ./rcdata.bin -b 4 -i 4 -p 4 -s 4 -k 0008a5ac -o outfile_test.bin
```
<img width="996" alt="image" src="https://user-images.githubusercontent.com/103949439/176466713-abd86c2b-d218-427d-8226-ce5ea1c35afe.png">


<p>
2. 
Run xor_d against file "rcdata.bin" with the same options as Example 1, except instead of outputing to a file, we are using the preview flag (-x) to peek at the first 500 decrypted bytes.
</p>

```
./xor_d.sh -f ./rcdata.bin -b 4 -i 4 -p 4 -s 4 -k 0008a5ac -x 500
```
<img width="1237" alt="image" src="https://user-images.githubusercontent.com/103949439/176464496-0888b196-e80f-4782-9045-bc4bc4ee8355.png">


