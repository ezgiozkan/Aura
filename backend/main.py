import os
import json
from fastapi import FastAPI, UploadFile, File, HTTPException
from pydantic import BaseModel
from typing import List
import google.generativeai as genai
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Initialize FastAPI app
app = FastAPI(
    title="Aura Backend API",
    description="AI-Powered Dating Assistant Backend for analyzing vibe and compatibility."
)

# --- CONFIGURATION ---
# Configure Google Gemini API
api_key = os.getenv(""
                    "")
if not api_key:
    raise ValueError("GOOGLE_API_KEY is missing in .env file")

genai.configure(api_key=api_key)

# Using 'gemini-2.5-flash' for speed and cost-efficiency.
model = genai.GenerativeModel('gemini-2.5-flash')


# --- DATA MODELS ---
class MatchResponse(BaseModel):
    score: int
    title: str
    description: str
    red_flags: List[str]
    green_flags: List[str]
    verdict: str

# --- RIZZ FEATURE MODELS ---

class RizzOption(BaseModel):
    text: str
    tone: str  # e.g., "Flirty", "Funny", "Mysterious"
    explanation: str # Why this line works

class RizzResponse(BaseModel):
    image_analysis: str
    options: List[RizzOption]

# --- ENDPOINTS ---

@app.get("/")
def read_root():
    """Health check endpoint to ensure the API is running."""
    return {"status": "Aura Backend is running!", "docs_url": "/docs"}


@app.post("/check-aura", response_model=MatchResponse)
async def check_aura(
        me: UploadFile = File(...),
        target: UploadFile = File(...)
):
    """
    Analyzes two uploaded images (User vs Target) to determine visual compatibility and vibe.
    Returns a JSON object with a score, verdict, and constructive feedback.
    """
    try:
        # Read image files as bytes
        me_bytes = await me.read()
        target_bytes = await target.read()

        # System Prompt for the AI
        prompt = """
        You are a brutally honest but constructive dating coach and vibe analyst. 
        Analyze these two people based on their visual "aura", style, grooming, and context.

        Person 1 is the USER. Person 2 is the TARGET.

        Task: Determine if Person 2 would be interested in Person 1 based on visual compatibility.

        Rules:
        1. Be realistic. If the styles clash heavily (e.g., one looks extremely messy/casual and the other is high-fashion/formal), point it out.
        2. Do NOT be mean about physical features (nose, height, etc.). Focus on "Vibe", "Style", "Effort", and "Energy".
        3. Give a compatibility score (0-100).
        4. If the score is low, say "Likely wouldn't look" but explain WHY based on presentation/vibe.
        5. Provide output strictly in JSON format.

        JSON Structure:
        {
            "score": 75,
            "title": "Short catchy title (e.g. 'High Risk, High Reward' or 'A Perfect Vibe Match')",
            "description": "2-3 sentences explaining the dynamic.",
            "red_flags": ["List 2 potential clashes (e.g., 'Target looks too high maintenance for User's chill vibe')"],
            "green_flags": ["List 2 matching points"],
            "verdict": "Direct answer: 'Yes, likely', 'Maybe with effort', or 'No, probably not'."
        }
        """

        # Prepare content for Gemini (Multimodal: Text + Image + Image)
        content = [
            prompt,
            {"mime_type": "image/jpeg", "data": me_bytes},
            {"mime_type": "image/jpeg", "data": target_bytes}
        ]

        # Generate response
        response = model.generate_content(content)

        # Clean up JSON string (remove markdown code blocks if present)
        cleaned_text = response.text.replace("```json", "").replace("```", "").strip()
        result = json.loads(cleaned_text)

        return result

    except Exception as e:
        print(f"Error during analysis: {e}")
        raise HTTPException(status_code=500, detail="Aura analysis failed. Please try again.")


@app.post("/generate-rizz", response_model=RizzResponse)
async def generate_rizz(
        image: UploadFile = File(...),
        extra_context: str = "Make it impressive but casual."
):
    """
    Analyzes an Instagram story screenshot and generates conversation starters (Rizz lines).
    """
    try:
        image_bytes = await image.read()

        # System Prompt: The "Rizz God" Persona
        prompt = f"""
        You are a world-class social dynamics expert and dating coach. 
        Your task is to generate the perfect "reply" to this Instagram Story.

        Context provided by user: {extra_context}

        Step 1: Analyze the image. Is it a selfie? Food? Travel? A meme? 
        Step 2: Generate 3 DISTINCT opening lines to start a conversation.

        Guidelines:
        - NO "Hi", "Hello", "Nice pic". Those are banned.
        - Be specific. If there is a cat, mention the cat. If it's sushi, mention the sushi.
        - Keep it short (Instagram DMs are quick).
        - Different vibes: 
            1. Funny/Witty (Playful teasing)
            2. Flirty/Bold (Direct interest)
            3. Casual/Observational (Low pressure)

        Return strictly JSON format:
        {{
            "image_analysis": "Brief description of what is in the photo (e.g., 'A golden retriever playing in a park')",
            "options": [
                {{ "tone": "Funny", "text": "...", "explanation": "..." }},
                {{ "tone": "Flirty", "text": "...", "explanation": "..." }},
                {{ "tone": "Casual", "text": "...", "explanation": "..." }}
            ]
        }}
        """

        content = [
            prompt,
            {"mime_type": "image/jpeg", "data": image_bytes}
        ]

        response = model.generate_content(content)

        # Clean up JSON
        cleaned_text = response.text.replace("```json", "").replace("```", "").strip()
        result = json.loads(cleaned_text)

        return result

    except Exception as e:
        print(f"Rizz generation error: {e}")
        raise HTTPException(status_code=500, detail="Rizz machine broken. Try again.")


if __name__ == "__main__":
    import uvicorn

    # Run the server
    uvicorn.run(app, host="0.0.0.0", port=8000)