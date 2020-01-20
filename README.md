# Scinable-iOS_Library-Swift-  
> iOS Notification Service를 위한 Static Library (Swift 작성)  

iOS 푸시알림을 위한 정적 라이브러리 코드, 이미지 푸시 서비스 및 푸시함, 웹뷰를  통한 광고기능 제공  
  
<img src="https://user-images.githubusercontent.com/48575996/72697865-e9a75180-3b84-11ea-8e8a-37782e53e123.png" width="20%"></img>
  
## 설정 방법

#### CSR 요청 및 발급  
1. 키체인 접근 >> 인증서 지원 -> 인증기관에서 인증서 요청 -> 사용자 이메일 주소 입력, 이름 입력, 디스크에 저장됨 선택 후 계속 클릭 -> 저장  
<img src="https://user-images.githubusercontent.com/48575996/67170862-47de6000-f3ef-11e9-8cdd-8dcb9256292e.png" width="30%"></img>  
  
2. App ID 만들기  
   1. Apple Developer 접속 -> [링크](https://developer.apple.com/kr/)  
   2. [Account] 탭 클릭 후 로그인 -> [Certificates, Identifiers & Profiles] 탭 클릭 -> [Identifiers] 탭 클릭 후 '+' 버튼 클릭 -> 'App IDs' 항목이 선택된 채로 Continue 버튼 클릭  
   3. 프로젝트의 Bundle ID와 Description을 입력 -> [Capabilities] 의 항목 중 'Push Notification'항목을 선택한 후 Continue 클릭 -> 확인 후 Register 클릭  
3. 인증서 등록  
   * Apple Developer 사이트 -> -Account- Certificates, Identifiers & Profiles에서 [Certificates] 탭 클릭 후 '+' 버튼 클릭 -> 'IOS App Development'선택 후 Continue 클릭 -> Choose File 키를 클릭하여 인증서 선택(키체인을 통해 발급해두었던 인증서를 등록), Continue 버튼 클릭 후 Download하여 원하는 위치에 저장 (.cer 파일) >> 키체인에서 좌측의 '로그인' 을 클릭하여 열어둔 상태로 둔 후, 조금 전에 Download 받았던 [ .cer] 파일을 더블클릭하고 새로운 인증서가 키체인 목록에 추가되는 것을 확인  
4. 디바이스 등록 : Apple Developer 사이트 - Account - Certificates, Identifiers & Profiles에서 [Devices] 탭 클릭 후 '+' 버튼 클릭 -> Device Name과 Device ID(UDID)를 작성한 후 Continue 버튼 클릭 -> 확인 후 Register 버튼 클릭  
5. 프로비저닝 프로파일 등록 : Apple Developer 사이트 -Account- Certificates, Identifiers & Profiles에서 [Profiles] 탭 클릭 후 '+' 버튼 클릭 -> 'IOS App Development' 항목 선택 후 Continue 클릭 -> 생성했던 App ID를 선택 후 Continue 클릭 -> 생성했던 인증서 선택 후 Continue  클릭 -> 등록한 디바이스 선택 후 Continue 클릭 -> 프로비저닝 프로파일의 이름을 설정한 후 Generate 버튼 클릭 -> Download 버튼 클릭하여 원하는 위치에 저장  
6. P12 인증키 생성 : Apple Developer 사이트 -Account- Certificates, Identifiers & Profiles에서 [Keys] 탭 클릭 후 '+' 버튼 클릭 -> Key Name 입력 및 'Apple Push Notifications service (APNs)' 항목 선택 후 Continue 버튼 클릭 -> 키 정보 확인 후 Register 버튼 클릭, Download 버튼 클릭하여 원하는 위치에 저장 (주의. 키를 다운로드 하면 이후에 다운로드 할 수 없음, 또한 파일 탐색으로 키를 검색할 수 없으니 저장한 위치를 잘 기억해 둘 것)  
#### FCM 등록  
1. Firebase Console 접속 -> [링크](https://firebase.google.com/?hl=ko)  
2. 시작하기 -> 프로젝트 추가 -> 원하는 프로젝트명 작성  
3. 앱 추가 Platfrom iOS 클릭 후 이동  
4. 본인의 프로젝트명 입력 ex) com.example.push_Example  
5. 제공되는 plist 파일을 설명대로 본인의 프로젝트에 추가
6. FCM에 등록한 앱 설정 -> [클라우드메시징] 탭으로 이동 [APN인증서] 선택 후 인증서 등록

#### 프로그램 설정
1. CoCoaPod
   1. 제공된 Podfile에서 '**MyProject**' 부분에 자신의 project 이름 입력  
   2. 터미널에서 프로젝트의 경로로 이동 후 `pod install` 명령어를 실행한다.  
2. XCode  
    1. Cocoapod을 통해 생성된 .xcworkspace를 실행  
    2. Project의 Build Phases 메뉴  
        1. Link Binary With Libraries 부분에 제공된 정적 라이브러리(.a) 추가  
        2. Embed App Extensions부분에 이미지 푸시를 위해 제공된 노티피케이션 확장 모듈 추가(.appex)  
        **".appex의 경우 제공전 경로를 고객의 project경로로 수정해야 오류가 안생긴다."**   
3. Swift  
    1. 토큰생성을 위한 makeToken메서드를 호출하기위해 디바이스로부터 값을 호출한뒤 넘겨준다.  
      ```sh
      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){  
           pushLib.makeToken(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)  
      }
      ```  
    2. 등록실패 처리를 위한 메소드를 호출하기위한 추가  
      ```sh
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){  
         pushLib.registerFail(application, didFailToRegisterForRemoteNotificationsWithError: error)  
      }
      ```  
    3. 서버로부터 메시지를 받았을때 처리를위한 메소드를 호출  
      ```sh
      func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any], fetchCompletionHandler       fatch: @escaping(UIBackgroundFetchResult)->Void){  
        pushLib.receiveMessage(application, didReceiveRemoteNotification: data, fetchCompletionHandler: fatch)  
      } 
      ```  
 4. Objective-C  
   1. Project 파일 안에 ProjectName으로된 Source code가 모인 파일에 제공되는 (.h)헤더파일 삽입  
   2. AppDelegate.m 에서 `#import "PushLib-Swift.h"`선언  
   3. @implementation단위 (swift에선 class와 동일)에서 `PushLib *ps` 선언으로 클래스 호출  
   4. Bool을 반환하는 application 메소드(기본으로 생성되어있다.)에서 `ps=[PushLib alloc]init];`으로 클래스 초기화  
   5. 메소드 추가
      1. 토큰생성을 위한 makeToken메서드를 호출하기위해 디바이스로부터 값을 호출한뒤 넘겨준다.  
      ```sh
       - (void)application:(UIApplication *)application
       didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
       [ps makeToken:application didRegisterForRemoteNotificationsWithDeviceToken: deviceToken];  
       }
      ```
      2.  등록실패 처리를 위한 메소드를 호출하기위한 추가  
      ```sh
       - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {  
       [ps registerFail:application didFailToRegisterForRemoteNotificationsWithError:error];  
       }
      ```
      3. 서버로부터 메시지를 받았을때 처리를위한 메소드를 호출  
      ```sh
       - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *) userInfo fetchCompletionHandler:          (void (^)(UIBackgroundFetchResult))completionHandler{  
       [ps receiveMessage:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];  
       }
      ```
   6. 오류발생시 Project -> New file -> swift파일 생성(해당파일은 빈파일)   
5. ios의 경우 푸시의 갯수인 뱃지룰 앱 단위에서 초기화해야 한다.  
     `applicationDidBecomeActivity`부분에 
         `application.applicationIconBadgeNumber = 0` 추가  
         
## 업데이트 내역

* 0.2.1  
    * Alert에 링크를 추가, 링크클릭시 웹뷰를 이용해 홍보용 사이트로 이동(userDefaults를 이용하여 url전달)  
* 0.2.0  
    * 추가: 푸시함 추가, 테이블뷰와 커스텀 셀을 이용해 리스트 구성 및 Alert을 커스터마이징하여 리스트 클릭시 내용을 띄우도록 구현  
* 0.1.3
    * 버그 수정 : Objective-C에서 라이브러리 사용시 함수들이 인식이 안되는 오류 발생  
    => 라이브러리의 XCode설정에서 `~.h`파일 생성하도록 설정 후 네임스페이스 @Objc를 추가하여 header에 함수들이 인식되도록 변경
* 0.1.2  
    * 버그 수정 : 서버에서 이미지URI 전송시 이미지 출력이 안되는 오류 발생  
    => php 서버에서 payload에 `mutable_content=true`, `content_available=true`로 설정하여 함께 전송하여 해결
* 0.1.1  
    * 버그 수정 : 안드로이드와 같은 php 사용시 전송이 안되는 오류 발생  
    => 기존의 notification payload 방식을 data payload방식으로 변경 후 플랫폼에 맞게 분기하도록 설정
* 0.1.0  
    * 생성된 토큰값을 Alamofire를 이용해 서버DB로 전송  
    * 백/ 포 그라운드에서 푸시를 받을 수 있도록 수정  
* 0.0.1  
    * notification을 위한 기본적인 코드 작성 (Extend Notification Service ) 

## 구현 정보


