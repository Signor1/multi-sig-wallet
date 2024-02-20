import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Multi-Signature Wallet Contract", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.

  const address1 = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
  const address2 = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
  const address3 = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";
  const address4 = "0x90F79bf6EB2c4f870365E785982E1f101E93b906";

  const addressZero = "0x0000000000000000000000000000000000000000";

  async function deployMultiSigWallet() {
    const signers = [address1, address2, address3, address4];

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const MultiSigWallet = await ethers.getContractFactory("MultiSigWallet");

    const multiSigWallet = await MultiSigWallet.deploy(signers, 3);

    return {
      multiSigWallet,
      owner,
      otherAccount,
      address1,
      address2,
      address3,
      address4,
    };
  }

  describe("Deployment check", function () {
    it("Should check if the contract was deployed", async function () {
      const { multiSigWallet } = await loadFixture(deployMultiSigWallet);

      expect(multiSigWallet).to.exist;
    });

    it("Should not deploy if there is an address zero amidst signers", async function () {
      async function checkWrongDeploy() {
        let signers = [address1, address1, addressZero];
        const MultiSigWallet = await ethers.getContractFactory(
          "MultiSigWallet"
        );

        const multiSigWallet = await MultiSigWallet.deploy(signers, 3);

        return { multiSigWallet };
      }

      await expect(loadFixture(checkWrongDeploy)).to.be.rejectedWith(
        "Address zero is not allowed"
      );
    });

    // it("Should receive and store the funds to lock", async function () {
    //   const { lock, lockedAmount } = await loadFixture(deployMultiSigWallet);

    //   expect(await ethers.provider.getBalance(lock.target)).to.equal(
    //     lockedAmount
    //   );
    // });

    // it("Should fail if the unlockTime is not in the future", async function () {
    //   // We don't use the fixture here because we want a different deployment
    //   const latestTime = await time.latest();
    //   const Lock = await ethers.getContractFactory("Lock");
    //   await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
    //     "Unlock time should be in the future"
    //   );
    // });
  });
  describe("Initiate Transaction Check", function () {
    it("Should not allow address zero as the reciever", async function () {
      const { multiSigWallet } = await loadFixture(deployMultiSigWallet);

      let amount = ethers.parseEther("1");

      const tx = await multiSigWallet.initiateTransaction(amount, addressZero);
      tx.wait();

      expect(tx).to.be.revertedWith("zero address detected");
    });
    it("Should not allow zero amount", async function () {
      const { multiSigWallet } = await loadFixture(deployMultiSigWallet);

      let address = "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a";

      await expect(
        multiSigWallet.initiateTransaction(0, address)
      ).to.be.revertedWith("no zero value allowed");
    });
  });
});
