import Social
import Accounts

class TwitterAPIRequest: NSObject {
  func sendTwitterRequest(requestURL: NSURL!,
    params: Dictionary<String, String>,
    delegate: TwitterAPIRequestDelegate?) {
      // get the account store
      let accountStore = ACAccountStore()
      // store twitter account type as we'll use this a couple of times'
      let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
      accountStore.requestAccessToAccountsWithType(twitterAccountType,
        options: nil,
        completion: {
          (Bool granted, NSError error) -> Void in
          if (!granted) {
            println("access not granted")
          } else {
            // get all twitter accounts
            let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
            if twitterAccounts.count == 0 {
              println("no twitter accounts configured")
              return
            } else {
              // create a request for the Social API
              let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                requestMethod: SLRequestMethod.GET,
                URL: requestURL,
                parameters: params
              )
              // set the account. Need to cast it because accountStore.accountsWithAccountType
              // returns AnyObject
              request.account = twitterAccounts[0] as ACAccount
              // perform the request
              request.performRequestWithHandler({
                (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
                delegate!.handleTwitterData(data, urlResponse: urlResponse, error: error, fromRequest: self)
              })
            }
          }
        }
      )
  }
}
