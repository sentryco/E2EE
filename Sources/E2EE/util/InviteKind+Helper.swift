import Foundation
import Cipher
import Dice
/**
 * - Description: Helpers for `InviteKind` protocol provide functionality to 
 *                encrypt and decrypt confirmation codes, and to generate and 
 *                retrieve cryptographic key pairs. These utilities ensure 
 *                secure invitation handling within the E2EE scheme.
 */
extension InviteKind {
   /**
    * Generates an encrypted confirmation code for use in the end-to-end encryption (E2EE) scheme.
    * - Description: This method takes the external public key and uses it to 
    *                encrypt a randomly generated confirmation code. The 
    *                encryption ensures that only the holder of the 
    *                corresponding private key can decrypt and access the 
    *                confirmation code, thus maintaining the integrity and 
    *                confidentiality of the transaction within the E2EE scheme.
    * - Fixme: ⚠️️ Rename the function to better reflect its purpose. like what?
    * - Fixme: ⚠️️ I guess we could randomnize this 4-6?
    * - Parameters:
    *   - extPubKey: The remote public key to encrypt the confirmation code with.
    * - Returns: The encrypted confirmation code.
    * - Throws: An error if the random password generator fails or if the encryption process fails.
    */
   public static func encryptedConfirmCode(extPubKey: String, confirmCodeSalt: Data) throws -> String {
      let recipe: RandPSW.PasswordRecipe = .init( // create a password recipe for 4 digits
         charCount: 0, // Number of characters in the password (0 means only digits)
         numCount: 4, // Number of digits in the password
         symCount: 0 // Number of symbols in the password (0 means no symbols)
      )
      // Generate a random 4-digit code using Dice (plaintext confirmation code)
      let confirmCode: String = try RandPSW.makeRandomWord(recipe: recipe)
      return try E2EE.getEncryptedCode(
         code: confirmCode, // The plaintext confirmation code to encrypt
         pubKey: extPubKey, // The remote public key to use for encryption
         privKey: try Self.getKeyPair().priv, // The private key to use for encryption
         confirmCodeSalt: confirmCodeSalt // The salt used for generating the shared key during encryption and decryption of the confirmation code
      ) // Encrypt the plaintext confirmation code with the remote public key
   }
   /**
    * Decrypted code for external-Key, priv-Key and confirm-code
    * - Description: This method decrypts the confirmation code that was 
    *                encrypted with the external public key. It ensures 
    *                that the code can only be accessed by the intended 
    *                recipient who possesses the corresponding private 
    *                key, thus maintaining the security of the E2EE scheme.
    * - Important: ⚠️️ Use `self.pubKey` on reciver and external `pubkey` on sender
    * - Parameters:
    *   - externalPubKey: External pub-key
    *   - confirmCodeSalt: The salt used for generating the shared key during encryption and decryption of the confirmation code.
    * - Returns: The decrypted confirmation code as a string.
    */
   public func getDecryptedConfirmCode(externalPubKey: String, confirmCodeSalt: Data) throws -> String {
      try E2EE.getDecryptedCode(
         code: self.confirmCode, // The encrypted confirmation code to decrypt
         pubKey: externalPubKey, // The remote public key to use for decryption
         privKey: try Self.getKeyPair().priv,
         confirmCodeSalt: confirmCodeSalt // The private key to use for decryption
      ) // Decrypt the encrypted confirmation code with the remote public key
   }
   /**
    * - Description: This method retrieves the decrypted confirmation code 
    *                using the external public key. It is designed to be 
    *                used by the invitee in the E2EE scheme to access the 
    *                confirmation code that was encrypted by the inviter.
    * - Important: ⚠️️ Only works for the "invitee" (not "inviter", use decryptCode call for "inviter" etc)
    * - Parameter confirmCodeSalt: The salt used for generating the shared key during encryption and decryption of the confirmation code.
    * - Returns: The decrypted confirmation code as a string.
    */
   public func getConfirmationCode(confirmCodeSalt: Data) throws -> String {
      try getDecryptedConfirmCode(
         externalPubKey: extPubKey,
         confirmCodeSalt: confirmCodeSalt // The remote public key to use for decryption
      ) // Decrypt the encrypted confirmation code using the remote public key
   }
}
