const state = {
  isLoading: false
}

const mutations = {
  setLoading(state, val) {
    state.isLoading = val
  }
}

const actions = {
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
