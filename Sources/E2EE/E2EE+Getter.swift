import Logger
import Foundation
import Cipher
import Key
/**
 * Getter
 */
extension E2EE {
   /**
    * Returns the "public-key" as a string for the specified "key-name"
    * - Description: This method retrieves the public key associated with 
    *                the given key name. The public key is used for 
    *                encrypting data that can only be decrypted by the 
    *                corresponding private key, which is securely stored 
    *                and managed.
    * - Parameters:
    *   - keyName: The name of the key to use for retrieving the public key
    *   - service: - Fixme: ⚠️️ add doc
    * - Throws: An error if the public key cannot be retrieved or converted to a string
    * - Returns: The public key as a string
    */
   public static func getPubKey(keyName: String, service: String) throws -> String {
      let pubKey: PubKey = try keyPair(key: keyName, service: service).pub // Retrieve the public key
      return try Cipher.exportPubKey(pubKey: pubKey) // Convert the public key to a string
   }
   /**
    * Return "private / public" key-pair for E2EE - "end to end encryption"
    * - Abstract: We store the "private-key" in Keychain, for reuse later, remote 
    *            peers will use the "pub-key" for future payloads etc
    * - Description: This method retrieves a cryptographic key pair consisting 
    *                of a private and a public key. The private key is securely 
    *                stored in the Keychain under the provided key name. If the 
    *                key pair does not exist in the Keychain, a new one is 
    *                generated and stored. The public key can be shared with 
    *                remote peers for secure communication.
    * - Remark: Reads from keychain if one exists or creates a new one
    * - Remark: We can also use privkey to get pub key: try `PubKey(rawRepresentation: privKey.publicKey.rawRepresentation)`
    * - Parameters:
    *   - keyName: - Fixme: ⚠️️ add doc
    *   - service: - Fixme: ⚠️️ add doc
    * - Returns: - Fixme: ⚠️️ add dox
    */
   internal static func getKeyPair(keyName: String, service: String) throws -> KeyPair {
      let keyQuery: KeyQuery = getKeyQuery(keyName: keyName, service: service) // Create keychain query (used to query keychain)
      guard let keyData: Data = {
         do { // Try to get keypair data from keychain
            // fix: store any first, then convert to data
            guard let keyData: Data = (try Key.read(keyQuery)) as? Data else {
               Logger.error("\(Trace.trace()) - key object not data")
               return nil
            } // If keypair data is not found, log an error and return nil
            return keyData // Return the keypair data
         } catch {
            Logger.info("\(Trace.trace())") // Log an info message if an error occurs while getting the keypair data
            return nil // Return nil if an error occurs while getting the keypair data
         }
      }() else { // If keypair data is not found in keychain, create and store a new one
         // - Fixme: ⚠️️ Maybe log this event as an info event?
         // If no existing key pair data is found in the keychain, a new key pair is created and stored in the keychain.
         // The keyQuery is used to specify the keychain attributes for the new key pair.
         // The newly created key pair is then returned.
         return try createNewKeyPair(keyQuery: keyQuery)
      }
      let privKey: PrivKey = try .init(rawRepresentation: keyData) // Create private key from keypair data
      return (
         priv: privKey, // The private key
         pub: privKey.publicKey // The public key derived from the private key
      ) // Return the private and public keys as a tuple
   }
}
