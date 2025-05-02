async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const EventManager = await ethers.getContractFactory("EventManager");
    const eventManager = await EventManager.deploy();
    await eventManager.deployed();
    console.log("EventManager deployed to:", eventManager.address);

    const FundManager = await ethers.getContractFactory("FundManager");
    const fundManager = await FundManager.deploy();
    await fundManager.deployed();
    console.log("FundManager deployed to:", fundManager.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
