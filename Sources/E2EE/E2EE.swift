import Foundation
import Cipher
import Key
/**
 * E2EE lib covers creating `end-to-end-encryption` between two peers
 * - Abstract: E2EE is used when encrypting transmissions
 * - Description: E2EE (End-to-End Encryption) is a security measure that 
 *                ensures data transmitted between two parties cannot be 
 *                intercepted and understood by any other party. It is used 
 *                in this context to secure the transmission of invites and 
 *                confirmation codes between peers.
 * - Remark: Creates a confirmation code that must be verified to avoid 
 *           potential "man-in-the-middle-attacks" etc
 * - Note: Nice example for `E2EE` in a chat app: 
 *           https://getstream.io/blog/ios-cryptokit-framework-chat/
 */
public final class E2EE {}

extension E2EE {
   /**
    * Needed for private / public `E2EE` (end-2-end-encryption)
    * - Description: This property holds the key pair used for end-to-end encryption. It is initially nil and gets populated when the key pair is generated or retrieved from the cache.
    */
   internal static var _keyPair: KeyPair?
   /**
    * Getter for keypair
    * - Abstract: This method retrieves the key pair for end-to-end 
    *             encryption. If a key pair is not already cached, it 
    *             generates a new one using the provided keychain key 
    *             and stores it for future use.
    * - Description: This method is responsible for retrieving or 
    *                generating a key pair for end-to-end encryption. 
    *                If a key pair is already cached, it returns that. 
    *                If not, it generates a new key pair using the 
    *                provided keychain key and stores it in the cache 
    *                for future use.
    * - Remark: This method is used for `BPInvite` perma-key not 
    *           `BSInvite` ephemeral-key
    * - Parameter key: `keychain key` for the KeyPair stored in 
    *                  Keychain
    * - Parameter service: - Fixme: ⚠️️ add dox
    * - Returns: - Fixme: ⚠️️ add doc
    */
   public static func keyPair(key: String, service: String) throws -> KeyPair {
      let keyPair: KeyPair = try _keyPair ?? getKeyPair(keyName: key, service: service) // Get the cached keypair or generate a new one if none exists
      if _keyPair == nil { _keyPair = keyPair } // Cache the keypair for later use
      return keyPair // Return the generated keypair
   }
}
