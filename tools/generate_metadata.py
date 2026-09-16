from pathlib import Path
import hashlib
import struct


APPLICATION_BIN = Path(
    "build/application/phoenix_application.bin"
)

METADATA_BIN = Path(
    "build/application/application_metadata.bin"
)

APPLICATION_MAGIC_NUMBER = 0x50484F58


def main() -> None:

    # Check that the application image exists.
    if not APPLICATION_BIN.exists():
        raise FileNotFoundError(
            f"Application binary not found: {APPLICATION_BIN}"
        )

    # Read the exact firmware bytes that will be installed.
    application_data = APPLICATION_BIN.read_bytes()

    # The image size is the number of bytes in the firmware binary.
    image_size = len(application_data)

    # Calculate SHA-256 of the exact application image.
    application_hash = hashlib.sha256(application_data).digest()

    # Create the metadata in little-endian format:
    #
    #   uint32_t magic
    #   uint32_t image_size
    #   uint8_t  hash[32]
    metadata = struct.pack(
        "<II",
        APPLICATION_MAGIC_NUMBER,
        image_size,
    ) + application_hash

    METADATA_BIN.write_bytes(metadata)

    print(f"Application size : {image_size} bytes")
    print(f"SHA-256          : {application_hash.hex()}")
    print(f"Metadata size    : {len(metadata)} bytes")
    print(f"Metadata file    : {METADATA_BIN}")


if __name__ == "__main__":
    main()