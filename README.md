# FetchingOTP

---
> 實作電話註冊與驗證碼的功能，但主要工作與難度是在輸入欄位的焦點移動

![demo_gif](./demo.gif "gif")

---

## 工作項目

* 建立文字欄位，能夠綁定focusState，根據輸入行為切換焦點(一般驗證碼會搭配六個文字輸入框)，當使用者輸入時，用for-in依序檢查每個欄位(有四種情境需要檢查)
  * 如果已經在最後一個欄位，當使用者持續輸入，就用最後輸入的字元，取代目前的欄位
  * 如果該欄位有值，且該欄位是目前的焦點，就將焦點跳到下一個欄位
  * 如果該欄位無值，而前一個欄位有值，就將焦點跳到前一個欄位

    那麼當使用者再次輸入時，會觸發更新函式；先符合第一項，因此用最後輸入的數值取代該欄位，接著符合第二項，將焦點跳到下一個欄位

    由此可知，這三個檢查項是有順序關係的，必須照這個順序執行
  * 最後是處理自動輸入，一般情境會是當使用者進入驗證頁面後，收到SMS訊息，下方鍵盤會彈出，並出現鍵盤建議，當使用者點選鍵盤建議之後，目前的焦點欄位就會被填入這六個字元；所以這邊要檢查欄位中是否有六個值，如果有，就將這個六個值拆開，依序填入六個欄位

    因此這個檢查項必須放在第一個，且如果觸發，將數字填到六個欄位之後，必須要return跳出，否則會繼續觸發後面的檢查，造成非預期錯誤

* 在firebase上開啟電話驗證(一共有三個步驟)
  * 先呼叫PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber)，取得verification code
  * 再用PhoneAuthProvider.provider().credential(withVerificationID:withVerificationCode)建立憑證
  * 最後透過Auth.auth().signIn傳入憑證進行登入
  * 另外建立一個enum State代表登入狀態，透過init時判斷目前是否已經有登入的使用者；並將結果透過@Published暴露出去，來控制程式啟動後顯示的頁面(顯示首頁或登入頁面)，enum case:signedIn(User)會關聯目前的使用者

* 透過navigationStack控制頁面導覽
  * 建立一個ViewFactory，接收一個enum Destination，根據enum case，回傳要前往的頁面
  * 建立一個coordinator，內部包含一個navigationPath，讓外部透過情境操作path(append, remove)，修改path會觸發navigationDestination，並傳入path中的值(前面定義的enum)
  * 在navigationDestination中呼叫ViewFactory的工廠方法，並傳入收到的參數(enum)，取得要前往的目標頁面

---
* 模擬器測試收不到SMS，所以可以點擊AutoFill，模擬插入鍵盤建議值；另外模擬器測試時使用預先定義的號碼0963091621，驗證碼則是123456
