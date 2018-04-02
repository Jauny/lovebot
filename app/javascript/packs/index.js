import Vue from 'vue/dist/vue.esm';

document.addEventListener('DOMContentLoaded', () => {
  const tweets = JSON.parse(document.getElementById('tweets').getAttribute('data'))

  new Vue({
    el: '#welcome',
    data: {
      message: 'salut ca va le monde',
      tweets
    }
  })
})
