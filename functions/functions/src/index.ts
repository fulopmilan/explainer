import * as dotenv from "dotenv";
dotenv.config();

import * as v2 from "firebase-functions/v2";
import OpenAI from "openai";


const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const callai = v2.https.onRequest((req, res) => {
  const unorderedChatHistory = req.body.data.text;
  const chatHistoryMessages: { role: string, content: string }[] = [];

  for (let i = 0; i < unorderedChatHistory.length; i++) {
    const chatHistoryMessage = {
      role: i % 2 == 0 ? "assistant" : "user", content: unorderedChatHistory[i],
    };
    chatHistoryMessages.push(chatHistoryMessage);
  }

  const systemMessage = {
    role: "system",
    content: `answer questions, use same language as first 
    message unless requested otherwise`,
  };

  async function callResponse() {
    const response = await openai.chat.completions.create({
      // gpt-3.5-turbo
      model: "gpt-3.5-turbo",
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      messages: [systemMessage as unknown as any, ...chatHistoryMessages],
    });
    return response;
  }

  callResponse().then((aiResponse) => {
    res.send({data: aiResponse.choices[0].message.content});
  });
});
