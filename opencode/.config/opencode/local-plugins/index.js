import subscriptionModelGuard from "./subscription-model-guard-v2.js";

const localPlugins = [subscriptionModelGuard];

export default {
  id: "local.oc-v2",
  async setup(context) {
    const cleanups = await Promise.all(localPlugins.map((plugin) => plugin.setup(context)));
    return async () => {
      await Promise.all(cleanups.filter(Boolean).map((cleanup) => cleanup()));
    };
  },
};
