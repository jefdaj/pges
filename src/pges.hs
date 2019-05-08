{-# LANGUAGE OverloadedStrings #-}

import Hakyll
import Data.Monoid ((<>))

main :: IO ()
main = hakyll $ do
  -- TODO default handler with 404 page?

  -- simple pages
  match "index.md"    markdownRules
  match "schedule.md" markdownRules
  match "venue.md"    markdownRules
  match "email.md"    markdownRules
  match "twitter.md"  markdownRules

  -- pages that load lists of images
  match "photos.md" $ galleryRules
    [ ("photos2016", "files/photos/2016/*.jpg")
    , ("photos2017", "files/photos/2017/*.jpg")
    ]

  -- pages that load lists of peoples' bios
  match "speakers.md"   $ peopleRules [("speakers", "speakers/*.md")]
  -- uncomment if doing the panel again
  -- also uncomment link in templates/menu.html
  -- match "panel.md"      $ peopleRules [("panel", "panel/*.md")]
  match "organizers.md" $ peopleRules
    [ ("current" , "organizers/current/*.md")
    , ("previous", "organizers/previous/*.md")
    ]

  -- files to load for use in the above pages
  match "**.md"       personRules
  match "templates/*" templateRules
  match "files/**.jpg" $ version "url" $ urlRules

  -- files to copy over unchanged
  match "css/*"        copyRules
  match "files/**.png" copyRules
  match "files/**.jpg" copyRules

-- The name of a list of things you want to use in a page,
-- along with a pattern describing which files to pull in.
-- Several functions below accept lists of NamedPatterns.
-- Examples:
--   ("speakers", "speakers/*.md")
--   ("photos2017", "files/2017/*.jpg")
type NamedPattern = (String, Pattern)

---------- TODO refactor this part! ----------

urlRules :: Rules ()
urlRules = compile $ do
  path <- fmap (\i -> '/': toFilePath i) getUnderlying
  makeItem path

urlList :: String -> String -> Pattern -> Compiler (Context a)
urlList s1 s2 ptn = do
  urls <- loadAll $ ptn .&&. hasVersion "url"
  return $ listField s1
              (field s2 (return . itemBody))
             (sequence $ map return urls)

-- TODO get old pamphlets from Daniel and add here?
galleryRules :: [NamedPattern] -> Rules ()
galleryRules fields = do
  route $ setExtension "html"
  compile $ pandocCompiler >> do
    let addList (name, ptn) = urlList name "src" ptn
    photoLists <- mapM addList fields
    let ctx = foldr (<>) defaultContext photoLists
    getResourceBody
      >>= applyAsTemplate ctx
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls

-----------------------------------------

markdownRules :: Rules ()
markdownRules = do
  route $ setExtension "html"
  compile $ pandocCompiler
    >>= loadAndApplyTemplate "templates/default.html" defaultContext
    >>= relativizeUrls

templateRules :: Rules ()
templateRules = compile templateBodyCompiler

copyRules :: Rules ()
copyRules = do
  route   idRoute
  compile copyFileCompiler

peopleRules :: [NamedPattern] -> Rules ()
peopleRules fields = do
  route $ setExtension "html"
  compile $ pandocCompiler >> do
    let addListField (name, ptn) = listField name defaultContext (loadAll ptn)
        ctx = foldr (<>) defaultContext $ map addListField fields
    getResourceBody
      >>= applyAsTemplate ctx -- fills in the templates
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls

personRules :: Rules ()
personRules = do
  compile $ pandocCompiler
    -- TODO where is this duplicated?
    -- >>= loadAndApplyTemplate "templates/person.html" defaultContext
    >>= relativizeUrls
