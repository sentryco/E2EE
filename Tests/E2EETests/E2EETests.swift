import XCTest
@testable import Dice
@testable import Cipher
@testable import E2EE
import CryptoKit

final class E2EETests: XCTestCase {
   /**
    * Tests
    */
   internal func testExample() {
      do {
         try codeTesting() // Confirm code handshake tests (high-level-test)
      } catch {
         Swift.print("error: \(error)")
      }
   }
}
/**
 * Tests
 */
extension E2EETests {
   /**
    * Code test
    * - Abstract: This test verifies the functionality of the E2EE 
    *             (End-to-End Encryption) module by encrypting and then 
    *             decrypting a code. It ensures that the module can 
    *             securely encrypt a message with a public key and 
    *             decrypt it back to its original form using the 
    *             corresponding private key.
    * - Description: This test ensures that the encryption and decryption 
    *                functions of the E2EE module are working as expected. 
    *                It does this by simulating a scenario where a code is 
    *                encrypted using a public key and then decrypted using 
    *                the corresponding private key. The test asserts that 
    *                the decrypted code matches the original code, verifying 
    *                the E2EE process's reliability.
    * - Note: This is a comprehensive test that simulates a real-world 
    *         scenario where a message (in this case, a code) is 
    *         encrypted by one party and sent to another, who then 
    *         decrypts it. The test checks if the decrypted message 
    *         matches the original, confirming the integrity and 
    *         effectiveness of the E2EE process.
    */
   fileprivate func codeTesting() throws {
      // Swift.print("E2EETests.codeTesting()")
      let remoteKeyPair: KeyPair = try Cipher.getKeyPair() // Generate a remote keypair using the `Cipher.getKeyPair` method, and assign it to `remoteKeyPair`
      let localKeyPair: KeyPair = try Cipher.getKeyPair() // Generate a local keypair using the `Cipher.getKeyPair` method, and assign it to `localKeyPair`
      E2EE._keyPair = localKeyPair // Set the `_keyPair` property of the `E2EE` class to the `localKeyPair`
      // By setting the `_keyPair` to code generated keypair, then using the encrypt code to test etc. similar to cipher test code we have now etc
      let code: String = try RandPSW.makeRandomWord(
         recipe: .init(
            charCount: 0, // The number of characters in the password
            numCount: 4, // The number of numbers in the password
            symCount: 0 // The number of symbols in the password
         )
      ) // Generate a random 4-digit code using the `RandPSW.getRandomPassword` method and assign it to `code`. The code will be used for testing purposes. The comments describe each line of code and its purpose.
      // Swift.print("code: \(code)")
      let remotePubKeyStr: String = try Cipher.exportPubKey(pubKey: remoteKeyPair.pub) // Export the public key of the `remoteKeyPair` object as a string and assign it to `remotePubKeyStr`
      let encryptedCode: String = try E2EE.getEncryptedCode(
         code: code, // The code to encrypt
         pubKey: remotePubKeyStr, // The public key of the remote party
         privKey: localKeyPair.priv,
         confirmCodeSalt: Cipher.defaultSalt // The private key of the local party
      ) // Encrypt the `code` using the `E2EE.encryptCode` method, the `remotePubKeyStr`, and the private key of the `localKeyPair` object, and assign the resulting encrypted code to `encryptedCode`. If the encryption fails, throw an error.
      // Swift.print("encryptedCode: \(encryptedCode)")
      let decryptedCode: String = try E2EE.getDecryptedCode(
         code: encryptedCode, // The encrypted code to decrypt
         pubKey: remotePubKeyStr, // The public key of the remote party
         privKey: localKeyPair.priv,
         confirmCodeSalt: Cipher.defaultSalt // The private key of the local party
      ) // Decrypt the `encryptedCode` using the `E2EE.decryptCode` method, the `remotePubKeyStr`, and the private key of the `localKeyPair` object, and assign the resulting decrypted code to `decryptedCode`. If the decryption fails, throw an error.
      // Swift.print("decryptedCode: \(decryptedCode)")
      let codesAreEqual = code == decryptedCode // Check if initial code is the same as the decrypted one
      Swift.print("E2EETests - codesAreEqual: \(codesAreEqual ? "✅" : "🚫")")
      XCTAssertTrue(codesAreEqual)
   }
}
