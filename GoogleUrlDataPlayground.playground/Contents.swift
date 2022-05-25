import UIKit
import GoogleUrlData

let url = URL(string: "https://www.google.com/maps/place/%D0%94%D0%B2%D0%BE%D1%80%D0%B5%D1%86+%D0%9D%D0%B8%D0%BC%D1%84%D0%B5%D0%BD%D0%B1%D1%83%D1%80%D0%B3/@48.1582638,11.5022729,3a,75y,359.89h,103.4t/data=!3m8!1e1!3m6!1sAF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE!2e10!3e11!6shttps:%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipOTx0xByeh0K1BiHeYeObGPZlsZQ2MCeiLrt9EE%3Dw203-h100-k-no-pi-13.395872-ya0.88743275-ro-0-fo100!7i8704!8i4352!4m7!3m6!1s0x479e77cc7fa2682d:0x274c5616a51e6d66!8m2!3d48.1582675!4d11.5033143!14m1!1BCgIgARICCAI")

if let url = url {
    let urlData = GoogleUrlData(url: url)
    let path = "4.3.8.3"
    print("\n\nData for " + path)
    print(urlData.urlDataRow(forPath: path)!)
    if let userContent = urlData.userContent,
       let contentUrl = URL(string: userContent) {
        print(contentUrl)
    }
} else {
    print("Bad url")
}
