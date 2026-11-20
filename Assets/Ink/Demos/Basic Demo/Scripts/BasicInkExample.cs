using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using Ink.Runtime;

public class BasicInkExample : MonoBehaviour {
    public static event Action<Story> OnCreateStory;

    [System.Serializable]
    public struct BackgroundEntry {
        public string tagName;
        public Sprite sprite;
        public Color tint;
    }

    [Header("Background Settings")]
    [SerializeField] private Image backgroundImage;
    [SerializeField] private List<BackgroundEntry> backgrounds;

    [Header("Ink Demo References")]
    [SerializeField] private TextAsset inkJSONAsset = null;
    public Story story;

    [SerializeField] private Canvas canvas = null;
    [SerializeField] private Text textPrefab = null;
    [SerializeField] private Button buttonPrefab = null;

    void Awake () {
        RemoveChildren();
        StartStory();
    }

    void StartStory () {
        story = new Story (inkJSONAsset.text);
        if(OnCreateStory != null) OnCreateStory(story);
        RefreshView();
    }

    void RefreshView () {
        RemoveChildren ();
        
        while (story.canContinue) {
            string text = story.Continue ();
            text = text.Trim();
            
            // Check tags on the current line
            HandleTags(story.currentTags);
            
            CreateContentView(text);
        }

        if(story.currentChoices.Count > 0) {
            for (int i = 0; i < story.currentChoices.Count; i++) {
                Choice choice = story.currentChoices [i];
                Button button = CreateChoiceView (choice.text.Trim ());
                button.onClick.AddListener (delegate {
                    OnClickChoiceButton (choice);
                });
            }
        }
        else {
            Button choice = CreateChoiceView("End of story.\nRestart?");
            choice.onClick.AddListener(delegate{
                StartStory();
            });
        }
    }

    void HandleTags(List<string> currentTags) {
        if (backgroundImage == null) return;

        foreach (string tag in currentTags) {
            string[] splitTag = tag.Split(':');
            if (splitTag.Length == 2 && splitTag[0].Trim().ToLower() == "bg") {
                string targetBg = splitTag[1].Trim().ToLower();
                
                foreach (var entry in backgrounds) {
                    if (entry.tagName.Trim().ToLower() == targetBg) {
                        if (entry.sprite != null) backgroundImage.sprite = entry.sprite;
                        backgroundImage.color = entry.tint.a > 0 ? entry.tint : Color.white;
                        break;
                    }
                }
            }
        }
    }

    void OnClickChoiceButton (Choice choice) {
        story.ChooseChoiceIndex (choice.index);
        RefreshView();
    }

    void CreateContentView (string text) {
        Text storyText = Instantiate (textPrefab) as Text;
        storyText.text = text;
        storyText.transform.SetParent (canvas.transform, false);
    }

    Button CreateChoiceView (string text) {
        Button choice = Instantiate (buttonPrefab) as Button;
        choice.transform.SetParent (canvas.transform, false);
        
        Text choiceText = choice.GetComponentInChildren<Text> ();
        choiceText.text = text;

        HorizontalLayoutGroup layoutGroup = choice.GetComponent <HorizontalLayoutGroup> ();
        layoutGroup.childForceExpandHeight = false;

        return choice;
    }

    // Keep the Background UI object when clearing story text/buttons
    void RemoveChildren () {
        int childCount = canvas.transform.childCount;
        for (int i = childCount - 1; i >= 0; --i) {
            Transform child = canvas.transform.GetChild(i);
            if (backgroundImage != null && child == backgroundImage.transform) {
                continue;
            }
            Destroy (child.gameObject);
        }
    }
}