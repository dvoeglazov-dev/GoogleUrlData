# GoogleUrlData

If you use Google Maps in your project, you might notice that photo URLs have unusual styled parameters, like `/data=!...` or `?pb=!`. For example, like this Opens Street panorama URL of the Nymphenburg Palace on Google Maps website:
<https://www.google.com/maps/place/%D0%94%D0%B2%D0%BE%D1%80%D0%B5%D1%86+%D0%9D%D0%B8%D0%BC%D1%84%D0%B5%D0%BD%D0%B1%D1%83%D1%80%D0%B3/@48.1582638,11.5022729,3a,75y,359.89h,103.4t/data=!3m8!1e1!3m6!1sAF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE!2e10!3e11!6shttps:%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE%3Dw203-h100-k-no-pi-13.395872-ya0.88743275-ro-0-fo100!7i8704!8i4352!4m7!3m6!1s0x479e77cc7fa2682d:0x274c5616a51e6d66!8m2!3d48.1582675!4d11.5033143!14m1!1BCgIgARICCAI>
Obviously, this URL contains information about place name, coordinates, Euler angles of seeing but other info is encoded with exclamation points notation.
Most of Street View and 360º Photo on Google Maps open through URLs with a similar format. Data parameters contain information about panorama id, 360º photo URL, image dimensions, coordinates and other.

I have not managed to find a description of this encoding or an existing decoding solution. I used materials from open sources and my own research to determine the parameters and decoding method I needed. I implemented it in this package.

The `GoogleUrlData` structure is used to parse such URLs and provide them in an easy-to-use form for 360º Photos on Google Maps.
Plain photo URLs also contain data with similar structure, but them has other indexes of fields and not yet added to this structure. You can determine it yourself and use index path to needed data (like "3.3.1") with `urlDataRow(forPath path: String) -> GoogleUrlDataRow?` func.  

I used info from this articles and discussions:
- <https://stackoverflow.com/questions/47017387/decoding-the-google-maps-embedded-parameters>
- <https://stackoverflow.com/questions/18413193/how-do-i-decode-encode-the-url-parameters-for-the-new-google-maps/34275131#34275131>
- <https://andrewwhitby.com/2014/09/09/google-maps-new-embed-format/>

## Data structure ##
Descibed data is an hyerarhical structure of elements, delimited by exclamation points. Data has an internal structure (‘bangs’). Each bang-group (call data) starts with an exclamation point, then has a single digit and a single character, followed by variable text. There seem to be two types of entity here:
* ![digit]m[digits] entities, which seem to indicate the start of a parameter group; at first I thought these were unique in a query but 3m2 appears twice, consistently. There’s probably some more structure I haven’t seen.
* other ![digit][char] entities, which seem to be parameters, where the digit is a sequence number (unique within the parameter group) and the char is a type indicator, with
	* d - double precision floating point
	* f - single precision floating point
	* i - integer
	* s - string
	* z - encoded data or an id or some kind
	* b - byte or boolean (?)
	* e - (?)
	* v - timestamp, unix epoch in milliseconds

## Parameter groups ##
Example of URL: ```<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3128.340699934565!2d-0.46482818466529047!3d38.3642391796565!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0xd62377123a70817%3A0x85e89b65fcf7c648!2sCalle+Cruz+de+Piedra%2C+4%2C+03015+Alicante!5e0!3m2!1ses!2ses!4v1476192292052" width="100%" height="350" frameborder="0" style="border:0" allowfullscreen=""></iframe>```
Matrices can encapsulate multiple data entries, e. g. !1m3!1i2!1i4!1i17 means that the matrix with the ID 1 contains the three integer values [2, 4, 17].
Parameters can be structured like this:

```!1m18
  !1m12
    !1m3
      !1d3128.340699934565
      !2d-0.46482818466529047
      !3d38.3642391796565
    !2m3
      !1f0
      !2f0
      !3f0
    !3m2
      !1i1024
      !2i768
      !4f13.1
  !3m3
    !1m2
      !1s0xd62377123a70817:0x85e89b65fcf7c648
      !2sCalle Cruz de Piedra, 4, 03015 Alicante
  !5e0
!3m2
  !1ses
  !2ses
!4v1476192292052```
