import Foundation
import Key
import Cipher
/**
 * `KeyChain` helpers
 * - Description: This section contains helper functions for interacting 
 *               with the iOS Keychain. These functions facilitate the 
 *               secure storage and retrieval of cryptographic keys used 
 *               in end-to-end encryption (E2EE) communication. The 
 *               Keychain is used to ensure that sensitive key material 
 *               is kept secure and is only accessible under certain 
 *               conditions, such as after the device has been unlocked.
 * - Fixme: ⚠️️ Investigate usage of `privateKeyUsage` and `applicationPassword` in `accessControl`
 */
extension E2EE {
   /**
    * KeyQuery to get priv-key from Keychain used for E2EE communcation
    * - Description: This method constructs a `KeyQuery` instance which is 
    *                used to interact with the iOS Keychain. It specifies 
    *                the conditions under which the private key can be 
    *                accessed, such as requiring the device to be unlocked 
    *                at least once after boot. This method is essential for 
    *                securely retrieving the private key needed for E2EE 
    *                communication without requiring biometric 
    *                authentication every time.
    * - Remark: By not having `BioAuth` here, we can access keychain 
    *           outside apples timelock, access to the app is still only 
    *           granted with `BioAuth`, later we might need to lock the 
    *           app after non-use etc, but open for sync etc, in the 
    *           future we could cache the sync, and apply it after the 
    *           fact
    * - Remark: `First-unlock` means device must be unlocked once after 
    *           the device is turned on etc
    * - Remark: We used `kSecAttrAccessibleWhenUnlocked` before, but 
    *           didn't work in "background" / "standby" mode etc that we 
    *           need for syncing in standby etc
    * - Remark: When you set share `keychain-group` in xCode target, 
    *           `accessGroup` can sometimes prepend 
    *           `$(AppIdentifierPrefix)` in `.entitlements`, remove that 
    *           part and things work 😅
    * - Remark: Since we don't need to use this keypair in the `AutoFill` 
    *           extension, we don't need to add `accessgroup` (I think)
    * - Parameter keyName: - Fixme: ⚠️️ add doc
    * - Parameter service: - Fixme: ⚠️️ add doc
    * - Returns: - Fixme: ⚠️️ add doc
    */
   public static func getKeyQuery(keyName: String, service: String) -> KeyQuery {
      // ⚠️️ used .userPresence before
      let accessControl: SecAccessControl? = SecAccessControlCreateWithFlags( // if context is not nil, use bio access, else use default access
         nil, // Use default protection
         kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, // Make the key accessible only after the first unlock and only on this device
         [], // Require user presence (e.g. Touch-ID or Face-ID) to use the key (not used in this code)
         nil // Do not specify any additional flags
      ) // Create an access control object for the keychain item
      return .init(
         key: keyName, // The name of the key
         service: service, // The name of the service
         accessGroup: nil, // The access group (not used in this code)
         accessControl: accessControl, // The access control object for the keychain item
         context: nil // The context (not used in this code)
      ) // Construct a query for the keychain item
   }
   /**
    * Returns new `KeyPair` (`priv-key` and `pub-key`) and stores it in keychain
    * - Description: This method generates a new cryptographic key pair, 
    *                consisting of a private key and a public key. The 
    *                private key is securely stored in the iOS Keychain for 
    *                future use, while the public key is returned along with 
    *                the private key as part of the key pair. This method 
    *                is used when a new key pair is needed for end-to-end 
    *                encryption (E2EE) communication.
    * - Parameter keyQuery: The `KeyQuery` to request `priv-key` from keychain
    */
   @discardableResult static func createNewKeyPair(keyQuery: KeyQuery) throws -> KeyPair {
      let keyPair: KeyPair = try Cipher.getKeyPair() // Generate a new keypair using the `Cipher.getKeyPair` function
      try Key.insert(
         data: keyPair.priv.rawRepresentation, // The private key data to insert
         query: keyQuery // The query to use for inserting the key
      ) // Insert the private key data into the keychain using the `Key.insert` function and the `keyQuery` parameter
      return keyPair // Return the generated keypair
   }
}
