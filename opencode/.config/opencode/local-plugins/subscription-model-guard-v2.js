const ALLOWED_AUTOMATIC_PROVIDERS = new Set(["openai"]);
const EXPLICIT_FALLBACK_AGENTS = new Set(["fallback-small", "fallback-large"]);

const AGENT_MODEL_OVERRIDES = {
  high: { providerID: "openai", id: "gpt-6.1-sol", variant: "high" },
  medium: { providerID: "openai", id: "gpt-5.6-terra", variant: "medium" },
  low: { providerID: "openai", id: "gpt-6-luna", variant: "low" },
};

const MODEL_REPLACEMENTS = {
  "openai/gpt-5.6-sol": "gpt-6.1-sol",
  "openai/gpt-5.6-luna": "gpt-6-luna",
};

const AGENT_TIERS = {
  plan: "high",
  prometheus: "high",
  atlas: "high",
  hephaestus: "high",
  sisyphus: "high",
  metis: "medium",
  oracle: "medium",
  "unspecified-high": "medium",
  build: "medium",
  general: "medium",
  momus: "medium",
  "sisyphus-junior": "medium",
  "OpenCode-Builder": "medium",
  "unspecified-medium": "medium",
  explore: "low",
  hermes: "low",
  librarian: "low",
  "multimodal-looker": "low",
  "unspecified-low": "low",
};

function agentName(agent) {
  return typeof agent.name === "string" ? agent.name : agent.id;
}

function modelKey(model) {
  if (!model?.providerID || !model?.id) return;
  return `${model.providerID}/${model.id}`;
}

export function applySubscriptionModelPolicy(agent) {
  const name = agentName(agent);
  const current = agent.model;
  const key = modelKey(current);

  if (!name || !current || !key || EXPLICIT_FALLBACK_AGENTS.has(name)) return false;

  const replacement = MODEL_REPLACEMENTS[key];
  if (replacement) {
    agent.model = { ...current, id: replacement };
    return true;
  }

  if (ALLOWED_AUTOMATIC_PROVIDERS.has(current.providerID)) return false;

  agent.model = { ...AGENT_MODEL_OVERRIDES[AGENT_TIERS[name] ?? "medium"] };
  return true;
}

const subscriptionModelGuard = {
  id: "local.subscription-model-guard-v2",
  async setup(context) {
    const registration = await context.agent.transform((editor) => {
      for (const agent of editor.list()) {
        editor.update(agent.id, (draft) => applySubscriptionModelPolicy(draft));
      }
    });

    return () => registration.dispose();
  },
};

export default subscriptionModelGuard;
