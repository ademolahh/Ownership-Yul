module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("Test", {
    from: deployer,
    log: true,
  });
};

module.exports.tags = ["all"];
