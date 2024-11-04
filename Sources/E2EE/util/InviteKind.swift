import Foundation
import Cipher
import Dice
/**
 * This enum is used to share common code between `BPInvite` (BluePeer) and `BSInvite` (BlueShare) - in the end-to-end encryption (E2EE) scheme for
 * - Description: The InviteKind protocol is a blueprint for creating different 
 *                types of invitations in the E2EE scheme. It provides the 
 *                structure for generating and managing the confirmation code and 
 *                external public key associated with an invite, as well as 
 *                generating a key pair for use in the E2EE scheme.
 * - Remark: It defines the different types of invitations that can be sent in the E2EE scheme.
 */
public protocol InviteKind: Codable {
   /**
    * Returns the confirmation code associated with the invite
    * - Description: This property returns the unique confirmation code that is 
    *                associated with the invite. This code is used to verify the 
    *                authenticity of the invite and ensure it was not tampered 
    *                with during transmission.
    */
   var confirmCode: String { get }
   /**
    * Returns the external public key associated with the invite
    * - Description: This property returns the external public key that is 
    *                associated with the invite. This key is used in the encryption 
    *                process to ensure secure communication.
    */
   var extPubKey: String { get }
   /**
    * Generates a key pair for use in the E2EE scheme, with the option to use a "permanent" or "ephemeral" key
    * - Description: This static method generates a cryptographic key pair 
    *                consisting of a private and a public key. These keys 
    *                are used in the E2EE scheme to encrypt and decrypt 
    *                messages, ensuring that only the intended recipient 
    *                can read them. The method may throw an error if key 
    *                generation fails.
    */
   static func getKeyPair() throws -> KeyPair
}
