const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners()
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
    const waveContract = await waveContractFactory.deploy()
    await waveContract.deployed()

    console.log("Contract deployed to:", waveContract.address)
    console.log("Contract deployed by:", owner.address)

    let waveCount
    waveCount = await waveContract.getTotalWaves()

    let waveTxn = await waveContract.wave()
    await waveTxn.wait()

    waveCount = await waveContract.getTotalWaves()

    waveTxn = await waveContract.connect(randomPerson).wave()

    waveCount = await waveContract.getTotalWaves()

    // storing list of addresses in an array
    const senderAddressStore = []
    senderAddressStore.push(waveTxn)
    const senderAddressList = senderAddressStore.map(sender => {
        return sender.from
    })
    console.log(senderAddressList)
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