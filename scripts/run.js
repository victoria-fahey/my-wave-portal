const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther('0.1'),})
    await waveContract.deployed()
    console.log('Contract addy: ', waveContract.address)

    // get wave count:
    let waveCount
    waveCount = await waveContract.getTotalWaves()
    console.log(waveCount.toNumber())

    // get contract balance:
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
    console.log('Contract balance: ', hre.ethers.utils.formatEther(contractBalance))

    // send wave:
    let waveTxn = await waveContract.wave('A message!')
    await waveTxn.wait()

    // get contract balance after we call wave to see what happened
    // to see if when we send a wave eth is properly removed from the contract
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
    console.log('Contract balance: ', hre.ethers.utils.formatEther(contractBalance))

    const [_, randomPerson] = await hre.ethers.getSigners()
    waveTxn = await waveContract.connect(randomPerson).wave('Another message!')
    await waveTxn.wait()

    let allWaves = await waveContract.getAllWaves()
    console.log(allWaves)
}

const runMain = async () => {
    try {
        await main()
        process.exit(0)
    } catch (err) {
        console.log(err)
        process.exit(1)
    }
}

runMain()