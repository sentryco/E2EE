import Foundation
import CryptoKit
import Cipher
/**
 * Code (Used for confirm code encrypted with E2EE)
 */
extension E2EE {
   /**
    * Encrypt `confirmation-code`
    * - Description: This method encrypts the provided confirmation code 
    *                using the given public and private keys. The encryption 
    *                process involves converting the confirmation code into 
    *                data, generating a shared key using the private key, 
    *                public key, and a predefined salt, and then encrypting 
    *                the confirmation code data with the shared key. The 
    *                result is a base64-encoded string of the encrypted 
    *                confirmation code.
    * - Fixme: ⚠️️ Add salt as a param?, or keep as is? We use const for salt etc, maybe
    * - Parameters:
    *   - code: Confirmation code (unencrypted)
    *   - pubKey: External pub-key (from remote peer)
    *   - privKey: Internal priv-key (local priv-key, usually stored in keychain)
    *   - confirmCodeSalt: The salt used for generating the shared key during encryption and decryption of the confirmation code.
    * - Returns: Encrypted confirmation code
    */
   public static func getEncryptedCode(code: String, pubKey: String, privKey: PrivKey, confirmCodeSalt: Data/* = Cipher.defaultSalt*/) throws -> String {
      // Attempt to convert the base64 encoded confirmation code into Data format
      guard let codeData: Data = .init(base64Encoded: code) else {
         throw NSError(domain: "⚠️️ err - code data", code: 0)
      } // Encode the confirmation code string as data
      let publicKey: PubKey = try Cipher.importPubKey(pubKey: pubKey) // Get the remote public key
      // Generate a shared key using the private key, public key, and confirmation code salt
      let sharedKey: SymmetricKey = try Cipher.getSharedKey(
         privKey: privKey, // The private key to use for generating the shared key
         pubKey: publicKey, // The public key to use for generating the shared key
         salt: confirmCodeSalt // The confirmation code salt to use for generating the shared key
      ) // Create a shared key between the local and remote peers
      let encryptedCodeData: Data = try Cipher.encrypt(
         data: codeData, // The data to encrypt
         key: sharedKey // The shared key to use for encryption
      ) // Encrypt the confirmation code data with the shared key
      return encryptedCodeData.base64EncodedString() // Return the encrypted confirmation code as a base64-encoded string
   }
   /**
    * Decrypt `confirmation-code`
    * - Description: This method decrypts the provided confirmation code 
    *                using the given public and private keys. The decryption 
    *                process involves converting the encrypted confirmation 
    *                code into data, generating a shared key using the private 
    *                key, public key, and a predefined salt, and then 
    *                decrypting the confirmation code data with the shared key. 
    *                The result is a base64-encoded string of the decrypted 
    *                confirmation code.
    * - Fixme: ⚠️️ Add salt as a param?, or keep as is? We use const for salt etc, maybe
    * - Parameters:
    *   - code: Confirmation code
    *   - pubKey: External pub-key
    *   - privKey: Internal priv-key
    *   - confirmCodeSalt: Make sure you use your own salt here
    * - Returns: Decrypted confirmation code
    */
   public static func getDecryptedCode(code: String, pubKey: String, privKey: PrivKey, confirmCodeSalt: Data/* = Cipher.defaultSalt*/) throws -> String {
      // Attempt to convert the base64 encoded encrypted confirmation code into Data format
      guard let codeData: Data = .init(base64Encoded: code) else {
         throw NSError(domain: "Err ⚠️️ - privateKeyBase64", code: 0)
      } // Encode the confirmation code string as data
      let publicKey: PubKey = try Cipher.importPubKey(
         pubKey: pubKey // The public key to use for generating the shared key
      ) // Get the remote public key
      let sharedKey: SymmetricKey = try Cipher.getSharedKey(
         privKey: privKey, // The private key to use for generating the shared key
         pubKey: publicKey, // The public key to use for generating the shared key
         salt: confirmCodeSalt // The confirmation code salt to use for generating the shared key
      ) // Create a shared key between the local and remote peers
      let decryptedCodeData: Data = try Cipher.decrypt(
         data: codeData, // The data to decrypt
         key: sharedKey // The shared key to use for decryption
      ) // Decrypt the confirmation code data with the shared key
      return decryptedCodeData.base64EncodedString() // Return the decrypted confirmation code as a base64-encoded string
   }
}
