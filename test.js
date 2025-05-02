const NSSConnect = artifacts.require("NSSConnect");

module.exports = async function(callback) {
  try {
    const instance = await NSSConnect.deployed();
    console.log(`Contract deployed at: ${instance.address}`);

    // Test getting event count
    const eventCount = await instance.getEventCount();
    console.log(`Event count: ${eventCount}`);

    callback();
  } catch (error) {
    console.error("Error:", error);
    callback(error);
  }
};
