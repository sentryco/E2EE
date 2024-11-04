# E2EE

> Encrypt communication with E2EE

## Description
E2EE is a system that ensures only the communicating users can read the messages. In principle, it prevents potential eavesdroppers – including telecom providers, Internet providers, and even the provider of the communication service – from being able to access the cryptographic keys needed to decrypt the conversation.

## Features
- **Local Keychain in Secure Enclave**: The private key is stored in the local keychain, which is a secure enclave that provides cryptographic operations and secure storage.
- **Different Salts**: E2EE uses different salts for different communication types, including "share", "sync", and "confirm".
- **Priv/Public Key Shared Key**: The system uses a shared key that is derived from the private and public keys.
- **Ephemeral Share-Code**: E2EE creates a temporary share-code that is used in the setup of the E2EE handshake.
 
## Example:

```swift
do {
    // Get the key pair using a specific key
    let keyPair = try E2EE.keyPair(key: "myKey")

    // Use the key pair for encryption or decryption
    // For example, to encrypt a message:
    let message = "Hello, world!"
    let encryptedMessage = try E2EE.encrypt(message: message, with: keyPair.publicKey)

    // And to decrypt it:
    let decryptedMessage = try E2EE.decrypt(encryptedMessage: encryptedMessage, with: keyPair.privateKey)

    print("Decrypted message: \(decryptedMessage)")
} catch {
    print("An error occurred: \(error)")
}
```

## Todo:
- Add a more detailed introduction about E2EE and its importance.
- Explain the terms used in the description section for better understanding.
- Include a section about how to install or use the E2EE in a project.
- Add error handling and what each error might mean.
