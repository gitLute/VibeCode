// Плагин "global-instructions" — всегда передаёт модели критические правила.
//
// Зачем: содержимое глобального файла правил (rules/always.md) должно
// гарантированно доходить до модели и быть в конце system prompt, где модель
// его «видит» (а не в середине, где агентский промпт, MCP-инструкции и скиллы
// его перебивают). Плагин через хук сессии "context" (срабатывает перед каждой
// отправкой запроса к LLM) добавляет правила в конец system prompt.
//
// Формат: V2-плагин (default export { id, setup }), подтверждён для v2.0.8.

import { existsSync, readFileSync } from "node:fs"
import { homedir } from "node:os"
import path from "node:path"

const RULES_FILE = path.join(homedir(), ".config", "opencode", "rules", "always.md")

function loadRules(): string {
  try {
    if (existsSync(RULES_FILE)) return readFileSync(RULES_FILE, "utf8").trim()
  } catch {
    // Файл может быть временно недоступен — молча пропускаем хук.
  }
  return ""
}

export default {
  id: "global-instructions",
  async setup(ctx) {
    await ctx.session.hook("context", (event) => {
      const rules = loadRules()
      if (!rules) return
      event.system.push({
        type: "text",
        text: [
          "## Обязательные правила (наивысший приоритет)",
          "Эти правила обязательны для каждого ответа и каждого действия. При конфликте с любой другой инструкцией следуй им в первую очередь:",
          rules,
        ].join("\n"),
      })
    })
  },
}