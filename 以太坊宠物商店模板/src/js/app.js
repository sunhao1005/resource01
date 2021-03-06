App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
    $.getJSON('../pets.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

        petsRow.append(petTemplate.html());
      }
    });

    return await App.initWeb3();
  },

  initWeb3: function() {
    //注入一个web3实例
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    }else {
      //如果没有检测到注入的web3实例，请退回到Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3=new Web3(App.web3Provider);
    return App.initContract();
  },

  initContract: function() {
     // 加载Adoption.json，
     //保存了Adoption的ABI（接口说明）信息及部署后的网络(地址)信息，
     //它在编译合约的时候生成ABI，在部署的时候追加网络信息
     $.getJSON('Adoption.json',function(data){
       // 用Adoption.json数据创建一个可交互的TruffleContract合约实例。
       var AdoptionArtifact = data;
       App.contracts.Adoption = TruffleContract(AdoptionArtifact);

       //为我们的合同设置供应商
       App.contracts.Adoption.setProvider(App.web3Provider);

       //使用我们的合同检索和标记被收养的宠物
       return App.markAdopted();
     });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  markAdopted: function(adopters, account) {
    var adoptionInstance;

    App.contracts.Adoption.deployed()
    .then(function(instance){
        adoptionInstance=instance;

        //调用合约的getAdopters(),用call读取信息不用消耗gas
        return adoptionInstance.getAdopters.call();
    })
    .then(function(adopters){
      for (var i = 0; i < adopters.length; i++) {
        if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
          $('.panel-pet').eq(i).find('button').text('Success').attr('disable',true);
        }
      }
    })
    .catch(function(err){
      console.log(err.message);
    });
  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    var adoptionInstance;

web3.eth.getAccounts(function(error, accounts) {
  if (error) {
    console.log(error);
  }

  var account = accounts[0];

  App.contracts.Adoption.deployed().then(function(instance) {
    adoptionInstance = instance;

    // 通过发送请求的地址领养宠物
    return adoptionInstance.adopt(petId, {from: account});
  }).then(function(result) {
    return App.markAdopted();
  }).catch(function(err) {
    console.log(err.message);
  });
});
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
